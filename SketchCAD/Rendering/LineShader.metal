//
//  LineShader.metal
//  SketchCAD
//
//  Created by Ramnath Pillai on 4/6/20.
//  Copyright © 2020 Oxymoron. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <metal_stdlib>
#include <simd/simd.h>

#import "../RendererConstants.h"

using namespace metal;

typedef struct
{
    // attribute(VertexAttributePosition) is related to
    // MTLVertexDescriptor attribute
    float4 thisVertex [[attribute(VertexAttributeThisVertex)]];;
    float4 nextVertex [[attribute(VertexAttributeNextVertex)]];;
    float4 prevVertex[[attribute(VertexAttributePrevVertex)]];;
    uint16_t colorIndex [[attribute(VertexAttributeColorIndex)]];
} VertexIn;

typedef struct
{
    // [[position]] denotes the clip space position
    float4 position [[position]];
    float4 color;
} VertexOut;

vertex VertexOut vertexShaderLine(VertexIn vertex_in [[stage_in]],
                              constant Colors *color_in [[buffer(BufferIndexColors)]],
                              constant Transforms& uniforms [[buffer(BufferIndexUniforms)]]) {
    VertexOut out;
    float4 clipSpaceThis = uniforms.projectionMatrix * uniforms.modelViewMatrix * vertex_in.thisVertex;
    float4 clipSpaceNext = uniforms.projectionMatrix * uniforms.modelViewMatrix * vertex_in.nextVertex;
    float4 clipSpacePrev = uniforms.projectionMatrix * uniforms.modelViewMatrix * vertex_in.prevVertex;
    
    // Find the tangent
    float4 dir = normalize(clipSpaceNext - clipSpaceThis);
    
    // Find the normal
    float4 normal = float4(-dir.y, dir.x, dir.z, dir.w);
    float thickness = 0.2;
    normal *= thickness/2.0;
    
    // TODO:
    
    
    
    
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * vertex_in.thisVertex;
    uint16_t ind = vertex_in.colorIndex;
    out.color = color_in[ind].color;
    return out;
     
}

fragment half4 fragmentShaderLine(VertexOut in [[stage_in]]) {
    
    return half4(in.color);
}
