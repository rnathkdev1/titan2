//
//  Renderer.swift
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/4/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

import Metal
import MetalKit
import simd

// The 16 byte aligned size of our transforms structure
let alignedUniformsSize = (MemoryLayout<Transforms>.size & ~0xF) + 0x10

let maxBuffersInFlight = 3

class Renderer: NSObject, MTKViewDelegate {
    
    // MARK: Properties
    let inFlightSemaphore = DispatchSemaphore(value: maxBuffersInFlight)
    let camera: Camera
    let commandQueue: MTLCommandQueue!
    let library: MTLLibrary!
    public let device: MTLDevice!
    
    var indexedVertices2D = [Vertex]()
    
    var dynamicUniformBuffer: MTLBuffer!
    
    // For max buffers in flight
    var uniformBufferIndex = 0
    var uniformBufferOffset = 0
    
    var vertexBuffer3D: MTLBuffer!
    var vertexBuffer2D: MTLBuffer!
    
    var colorBuffer: MTLBuffer!
    
    var sketchableLine = [Sketchable]()
    var sketchable3D = [Sketchable]()
    var sketchable2D = [Sketchable]()
    
    var vertexCount3D = 0
    var vertexCount2D = 0
    
    var indexBuffer: MTLBuffer!
    var uniforms: UnsafeMutablePointer<Transforms>!
    
    var projectionMatrix: matrix_float4x4 = matrix_float4x4()
    var rotation: Float = 0
    
    var pipelineState3D: MTLRenderPipelineState!
    var pipelineState2D: MTLRenderPipelineState!
    
    var depthState: MTLDepthStencilState!
    
    
    // MARK: Init method
    init?(canvas: MTKView) {
        self.device = canvas.device! // If failed, it should crash!
        
        self.camera = Camera(canvas: canvas)
        
        guard let queue = self.device.makeCommandQueue() else {
            return nil
        }
        
        self.commandQueue = queue
        self.library = device.makeDefaultLibrary()
        
        super.init();
        
        setupConstantColorBuffer()
        
        // Setup uniform buffer for transform
        let uniformBufferSize = alignedUniformsSize * maxBuffersInFlight
        guard let buffer = self.device.makeBuffer(length:uniformBufferSize, options:[MTLResourceOptions.storageModeShared]) else {
            return nil;
        }
        
        self.dynamicUniformBuffer = buffer
        self.dynamicUniformBuffer.label = "UniformBuffer"
        self.uniforms = UnsafeMutableRawPointer(dynamicUniformBuffer.contents()).bindMemory(to:Transforms.self, capacity:1)
        
        canvas.depthStencilPixelFormat = .depth32Float_stencil8
        canvas.colorPixelFormat = .bgra8Unorm
        canvas.sampleCount = 4;
        canvas.clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0)
        
        let mtlVertexDescriptor3D = Renderer.buildMetalVertexDescriptor3D()
        
        do {
            self.pipelineState3D = try buildRenderPipelineWithDevice(device: device,
                                                                     canvas: canvas,
                                                                     mtlVertexDescriptor: mtlVertexDescriptor3D,
                                                                     vertexShader: "vertexShader3D",
                                                                     fragmentShader: "fragmentShader3D",
                                                                     label: "3D Pipeline State")
            
            self.pipelineState2D = try buildRenderPipelineWithDevice(device: device,
                                                                     canvas: canvas,
                                                                     mtlVertexDescriptor: mtlVertexDescriptor3D,
                                                                     vertexShader: "vertexShader2D",
                                                                     fragmentShader: "fragmentShader2D",
                                                                     label: "2D Pipeline State")
 
        } catch {
            print("Unable to compile render pipeline state.  Error info: \(error)")
            return nil
        }
        
        let depthStateDesciptor = MTLDepthStencilDescriptor()
        depthStateDesciptor.depthCompareFunction = MTLCompareFunction.less
        depthStateDesciptor.isDepthWriteEnabled = true
        guard let state = device.makeDepthStencilState(descriptor:depthStateDesciptor) else {
            return nil
        }
        
        self.depthState = state
        
    }
    
    
    
    // MARK: Methods
    func setupConstantColorBuffer() {
        // Look into the ColorConstants and setup the buffer
        var colors = [SIMD4<Float>]()
        
        for t in ColorIndex.allCases {
            colors.append(t.getColorValues())
        }
        
        self.colorBuffer = device.makeBuffer(bytes: colors, length: colors.count * MemoryLayout<SIMD4<Float>>.stride, options: [])
    }
    
    class func buildMetalVertexDescriptor3D() -> MTLVertexDescriptor {
        let mtlVertexDescriptor = MTLVertexDescriptor()
        
        // Vertex descriptor is the following:
        //----------------------------|
        //| x   y   z  1 | ColorIndex |
        //----------------------------| - Buffer 0
        //|  Attribute 0 | Attribute 1|
        //----------------------------|
        
        // There is one SIMD4<Float> color and one index in a single struct.
        // Both are part of the same vertex buffer.
        mtlVertexDescriptor.attributes[VertexAttribute.position3D.rawValue].format = MTLVertexFormat.float4
        mtlVertexDescriptor.attributes[VertexAttribute.position3D.rawValue].offset = 0
        mtlVertexDescriptor.attributes[VertexAttribute.position3D.rawValue].bufferIndex = BufferIndex.positions3D.rawValue
        
        mtlVertexDescriptor.attributes[VertexAttribute.index.rawValue].format = MTLVertexFormat.ushort
        mtlVertexDescriptor.attributes[VertexAttribute.index.rawValue].offset = MemoryLayout<SIMD4<Float>>.stride
        mtlVertexDescriptor.attributes[VertexAttribute.position3D.rawValue].bufferIndex = BufferIndex.positions3D.rawValue
    
        mtlVertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return mtlVertexDescriptor
    }
    
    func buildRenderPipelineWithDevice(device: MTLDevice,
                                         canvas: MTKView,
                                         mtlVertexDescriptor: MTLVertexDescriptor,
                                         vertexShader: String,
                                         fragmentShader: String,
                                         label: String) throws -> MTLRenderPipelineState {
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor();
        
        let vertexFunction = library?.makeFunction(name: vertexShader)
        let fragmentFunction = library?.makeFunction(name: fragmentShader)
        
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = mtlVertexDescriptor
        pipelineDescriptor.label = label
        
        configureRenderPipelineDescriptor(device: device,
                                          canvas: canvas,
                                          pipelineDescriptor: pipelineDescriptor)
        
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
    }
    
    func configureRenderPipelineDescriptor(device: MTLDevice,
                                           canvas: MTKView,
                                           pipelineDescriptor: MTLRenderPipelineDescriptor) {
        
        pipelineDescriptor.sampleCount = canvas.sampleCount
        pipelineDescriptor.colorAttachments[0].pixelFormat = canvas.colorPixelFormat
        
        // Configure blending
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true;
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        pipelineDescriptor.depthAttachmentPixelFormat = canvas.depthStencilPixelFormat
        pipelineDescriptor.stencilAttachmentPixelFormat = canvas.depthStencilPixelFormat
    }
    
    private func updateDynamicBufferState() {
        /// Update the state of our uniform buffers before rendering
        
        uniformBufferIndex = (uniformBufferIndex + 1) % maxBuffersInFlight
        
        uniformBufferOffset = alignedUniformsSize * uniformBufferIndex
        
        uniforms = UnsafeMutableRawPointer(dynamicUniformBuffer.contents() + uniformBufferOffset).bindMemory(to:Transforms.self, capacity:1)
    }
    
    private func updateGameState() {
        // Update any game state before rendering
        let step = Float(0.01);
        uniforms[0].projectionMatrix = self.camera.projectionMatrix
        let modelMatrix = matrix4x4_rotation(rotation, vector_float3(1, 0, 0))
        let viewMatrix = self.camera.viewMatrix
        uniforms[0].modelViewMatrix = simd_mul(viewMatrix, modelMatrix)
        rotation += step;
    }
    
    func addObject3D(curve: Sketchable) {
        sketchable3D.append(curve)
        
        // FIXME: new buffer with every object added. Change to preallocate
        var vertices = [Vertex]()
        for sketchable in sketchable3D {
            vertices.append(contentsOf: sketchable.sketchableVertices)
        }
        
        vertexBuffer3D = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.stride,
                                         options: [])!
    }
    
    func addVertices2D(vertices: [Vertex]) {
        indexedVertices2D.append(contentsOf: vertices)
        vertexBuffer2D = device.makeBuffer(bytes: indexedVertices2D,
                                          length: indexedVertices2D.count * MemoryLayout<Vertex>.stride,
                                          options: [])!
        vertexCount2D = indexedVertices2D.count
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.camera.updateViewFromBounds(size: view.bounds.size);
    }
    
    func draw(in view: MTKView) {
        // Grab a semaphore and wait on it till it signals back.
        _ = inFlightSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        if let commandBuffer = commandQueue.makeCommandBuffer() {
            
            // Add a signal callback.
            let semaphore = inFlightSemaphore
            commandBuffer.addCompletedHandler { (_ commandBuffer)-> Swift.Void in
                semaphore.signal()
            }
            
            self.updateDynamicBufferState()
            self.updateGameState();
            
            /// Delay getting the currentRenderPassDescriptor until we absolutely need it to avoid
            ///   holding onto the drawable and blocking the display pipeline any longer than necessary
            let renderPassDescriptor = view.currentRenderPassDescriptor
            
            if let renderPassDescriptor = renderPassDescriptor, let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
                /// Final pass rendering code here
                renderEncoder.label = "Primary Render Encoder"
                renderEncoder.setCullMode(.none)
                renderEncoder.setFrontFacing(.counterClockwise)
                renderEncoder.setDepthStencilState(depthState)
                
                
                ////////// BEGIN 3D RENDERING //////////
                renderEncoder.pushDebugGroup("3D Rendering")
                renderEncoder.setRenderPipelineState(pipelineState3D)
                
                //TODO: Remove this condition.
                if sketchable3D.count > 0 {
                    
                    // Position buffer
                    renderEncoder.setVertexBuffer(vertexBuffer3D, offset: 0, index: BufferIndex.positions3D.rawValue)
                    
                    // Color vertex buffer
                    renderEncoder.setVertexBuffer(colorBuffer, offset: 0, index: BufferIndex.colors.rawValue)
                    
                    // Uniforms
                    renderEncoder.setVertexBuffer(dynamicUniformBuffer, offset:uniformBufferOffset, index: BufferIndex.uniforms.rawValue)
                    
                    // And finally, we draw each of them
                    var offset = 0
                    
                    // FIXME: Parallellize this
                    for obj in self.sketchable3D {
                        let countVertices = obj.sketchableVertices.count
                        
                        renderEncoder.setVertexBufferOffset(offset,
                                                            index: BufferIndex.positions3D.rawValue)
                        renderEncoder.drawPrimitives(type: obj.primitiveType,
                                                     vertexStart: 0,
                                                     vertexCount: countVertices)
                        
                        // Calculate offset for next drawable
                        offset += countVertices * MemoryLayout<Vertex>.stride
                    }
                }
                
                renderEncoder.popDebugGroup()
                ////////// END 3D RENDERING //////////
 
                /*
                ////////// BEGIN 2D RENDERING //////////
                renderEncoder.pushDebugGroup("2D Rendering")
                renderEncoder.setRenderPipelineState(pipelineState2D)
                
                if indexedVertices2D.count > 0 {
                    // Set 2D position buffer
                    renderEncoder.setVertexBuffer(vertexBuffer2D, offset: 0, index: BufferIndex.positions3D.rawValue)
                    
                    // And finally, we draw
                    renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount2D)
                }
                
                renderEncoder.popDebugGroup()
                ////////// END 2D RENDERING //////////
                 */
                renderEncoder.endEncoding()
            
                if let drawable = view.currentDrawable {
                    commandBuffer.present(drawable)
                }
            }
            commandBuffer.commit()
        }
    }
}


// Generic matrix math utility functions
func matrix4x4_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float4x4 {
    let unitAxis = normalize(axis)
    let ct = cosf(radians)
    let st = sinf(radians)
    let ci = 1 - ct
    let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
    return matrix_float4x4.init(columns:(vector_float4(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                                         vector_float4(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                                         vector_float4(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                                         vector_float4(                  0,                   0,                   0, 1)))
}

func matrix4x4_translation(_ translationX: Float, _ translationY: Float, _ translationZ: Float) -> matrix_float4x4 {
    return matrix_float4x4.init(columns:(vector_float4(1, 0, 0, 0),
                                         vector_float4(0, 1, 0, 0),
                                         vector_float4(0, 0, 1, 0),
                                         vector_float4(translationX, translationY, translationZ, 1)))
}

func matrix_perspective_right_hand(fovyRadians fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
    let ys = 1 / tanf(fovy * 0.5)
    let xs = ys / aspectRatio
    let zs = farZ / (nearZ - farZ)
    return matrix_float4x4.init(columns:(vector_float4(xs,  0, 0,   0),
                                         vector_float4( 0, ys, 0,   0),
                                         vector_float4( 0,  0, zs, -1),
                                         vector_float4( 0,  0, zs * nearZ, 0)))
}

func radians_from_degrees(_ degrees: Float) -> Float {
    return (degrees / 180) * .pi
}


