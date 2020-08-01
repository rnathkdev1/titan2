//
//  ScreenspaceLineShader.metal
//  SketchCAD
//
//  Created by Ramnath Pillai on 8/1/20.
//  Copyright © 2020 Oxymoron. All rights reserved.
//  This is the shader for screenspace lines.

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
    float thickness[[attribute(VertexAttributeDirection)]];
    ushort colorIndex [[attribute(VertexAttributeLineColorIndex)]];
} VertexIn;

typedef struct {
    float4 position [[position]];
    float4 color;
} VertexOut;

vertex VertexOut vertexShaderScreenspaceLine(VertexIn vertex_in [[stage_in]],
                                constant Colors *color_in [[buffer(BufferIndexColors)]],
                                constant Transforms& uniforms [[buffer(BufferIndexUniforms)]]) {
    VertexOut out;
    float4 clipSpaceThis = uniforms.screenspaceProjectionMatrix * vertex_in.thisVertex;
    float4 clipSpaceNext = uniforms.screenspaceProjectionMatrix * vertex_in.nextVertex;
    float4 clipSpacePrev = uniforms.screenspaceProjectionMatrix * vertex_in.prevVertex;
    
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
    float thickness = abs(vertex_in.thickness);
    normal *= thickness/2.0;
    normal.x /= uniforms.aspectRatio;
    
    // Offset the point in the direction
    if (vertex_in.thickness < 0) {
        normal *= -1;
    }
    
    float4 offset = float4(normal.x, normal.y, 0.0, 0.0);
    
    // Return the clip space point
    out.position = clipSpaceThis + offset;
    uint16_t ind = vertex_in.colorIndex;
    out.color = color_in[ind].color;
    return out;
}


fragment half4 fragmentShaderScreenspaceLine(VertexOut in [[stage_in]]) {
    return half4(in.color);
}