
# Camera组件

![输入图片说明](../../assets/Unity/20230118.png)

运行的CameraTag 应该为 MainCamera

## Projecttion

## Rendering

![输入图片说明](../../assets/Unity/image2023011801.png)

- Renderer
- PostProcession
- Anti-aliasing
- StopNan
- Dithering：


- RenderShadows
- Priority
- OpaqueTexture
- DepthTexture
- CullingMask：剔除遮罩，勾选要渲染的层，注意：如果不勾选，不仅不渲染，且不会响应射线事件
- OcclusionCulling


## Envrionment


## Output

## Stack


# PhysicsRaycaster

用于射线检测，可对场景中的数据进行交互

![输入图片说明](../../assets/Unity/image2023011802.png)


- EventMask：这里勾选需要交互的层级，同时注意在Camera->Renderer->CullingMask 中也要勾选响应的层级
- MaxRayIntersections: 最大射线距离

