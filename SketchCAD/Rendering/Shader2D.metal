//
//  Shader2D.metal
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/10/19.
//  Copyright © 2019 Oxymoron. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>

#import "../RendererConstants.h"

using namespace metal;

typedef struct
{
    // attribute(VertexAttributePosition) is related to
    // MTLVertexDescriptor attribute
    float4 position [[attribute(VertexAttributePosition3D)]];
    uint16_t colorIndex [[attribute(VertexAttributeIndex)]];
} VertexIn;

typedef struct
{
    // [[position]] denotes the clip space position
    float4 position [[position]];
    float4 color;
} VertexOut;

vertex VertexOut vertexShader2D(VertexIn vertex_in [[stage_in]],
                                constant Colors *color_in [[buffer(BufferIndexColors)]]) {
    VertexOut out;
    out.position = vertex_in.position;
    uint16_t ind = vertex_in.colorIndex;
    out.color = color_in[ind].color;
    return out;
}

fragment half4 fragmentShader2D(VertexOut in [[stage_in]]) {
    return half4(in.color);
}
