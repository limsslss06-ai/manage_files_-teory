# 优先级层（priority）

`<priority>` 定义代码的抽象层级和**依赖方向**，是四维坐标中最重要的维度。

## 取值
| 层级      | 含义               | 依赖规则                     |
|-----------|--------------------|------------------------------|
| core      | 语言/基础层        | 不依赖任何其他层             |
| framework | 逻辑/算法层        | 只能依赖 core                |
| modules   | 能力/系统层        | 依赖 core + framework        |

## 判定
|外来库使用数量| 层级 |
|-------------|--------------------|
| 0           | core        |
| 1           | framework   |
| N           | modules     |


## 铁律

- 依赖只能**向下**：modules → framework → core。
- **禁止环形依赖**：任何两个层之间不得相互依赖。
- core 层必须保持**技术中立**，不得引入任何具体第三方库或操作系统 API。
- framework 层只能定义抽象接口和算法，**不得绑定具体技术实现**。
- modules 层负责对接外部世界（操作系统、第三方库），**必须明确其 domain**。

## 示例

- `core/math/algorithm`：基础数学算法，不依赖任何外部库。
- `framework/video/interface`：视频解码抽象接口。
- `modules/video/ffmpeg/backend`：基于 FFmpeg 的具体实现。