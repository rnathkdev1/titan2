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
/*
typedef struct
{
    // attribute(VertexAttributePosition) is related to
    // MTLVertexDescriptor attribute
    //float4 position [[attribute(VertexAttributePosition3D)]];
    uint16_t vertexIndex [[attribute(VertexAttributePosition3D)]];;
    uint16_t nextVertexIndex [[attribute(1)]];;
    uint16_t prevVertexIndex [[attribute(10)]];;
    uint16_t colorIndex [[attribute(VertexAttributeIndex)]];
} VertexIn;

typedef struct
{
    // [[position]] denotes the clip space position
    float4 position [[position]];
    float4 color;
} VertexOut;

vertex VertexOut vertexShader3D(VertexIn vertex_in [[stage_in]],
                              constant Colors *color_in [[buffer(BufferIndexColors)]],
                              constant Transforms& uniforms [[buffer(BufferIndexUniforms)]]) {
    
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * vertex_in.position;
    uint16_t ind = vertex_in.colorIndex;
    out.color = color_in[ind].color;
    return out;
     
}

fragment half4 fragmentShader3D(VertexOut in [[stage_in]]) {
    
    return half4(in.color);
}
*/
