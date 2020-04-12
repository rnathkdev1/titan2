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
    int32_t direction[[attribute(VertexAttributeDirection)]];
    ushort colorIndex [[attribute(VertexAttributeLineColorIndex)]];
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
    
    float4 thisToNDC = clipSpaceThis/clipSpaceThis.w;
    float4 nextToNDC = clipSpaceNext/clipSpaceNext.w;
    float4 prevToNDC = clipSpacePrev/clipSpacePrev.w;
    
    float2 thisNDC = float2(thisToNDC.x, thisToNDC.y);
    float2 nextNDC = float2(nextToNDC.x, nextToNDC.y);
    float2 prevNDC = float2(prevToNDC.x, prevToNDC.y);
    
    // Transform to screen space
    thisNDC *= uniforms.aspectRatio;
    nextNDC *= uniforms.aspectRatio;
    prevNDC *= uniforms.aspectRatio;
    
    // Find the tangent
    float2 dir;
    if (vertex_in.nextVertex.w > 0)
        dir = normalize(nextNDC - thisNDC);
    else
        dir = normalize(thisNDC - prevNDC);
    
    // Find the normal
    float2 normal = float2(-dir.y, dir.x);
    
    // Extrude from center and correct aspect ratio
    float thickness = 0.4;
    normal *= thickness/2.0;
    normal.x /= uniforms.aspectRatio;
    
    // Offset the point in the direction
    normal *= vertex_in.direction;
    
    float4 offset = float4(normal.x, normal.y, 0.0, 1);
    
    // Return the clip space point
    out.position = clipSpaceThis + offset;
    uint16_t ind = vertex_in.colorIndex;
    out.color = color_in[ind].color;
    return out;
}

fragment half4 fragmentShaderLine(VertexOut in [[stage_in]]) {
    return half4(in.color);
}
