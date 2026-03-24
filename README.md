# GoldPriceWidget

一个原生 `macOS + WidgetKit` 的沪金桌面小组件示例工程，目标是以桌面 Widget 的方式展示上海黄金交易所金价。

## 功能

- 宿主应用中配置并保存 `Jisu API AppKey`
- 通过共享 `App Group` 缓存最新金价快照
- `small` / `medium` 两种 Widget 展示规格
- 显示当前价格、涨跌、更新时间和错误/缓存提示
- 宿主应用手动刷新后触发 Widget 时间线重载

## 数据源

当前默认接入极速数据的上海黄金交易所接口：

- 接口地址：`https://api.jisuapi.com/gold/shgold`
- 价格口径：默认优先选择 `Au99.99`
- 鉴权方式：`appkey` 查询参数

如需切换到其它沪金/上金所品种，可在 `GoldPriceWidgetShared/Models/ShgoldInstrument.swift` 中扩展匹配规则。

## 本地使用

1. 安装完整 Xcode。
2. 在项目根目录执行 `xcodegen generate`。
3. 用 Xcode 打开 `GoldPriceWidget.xcodeproj`。
4. 在 Signing 中为 App 与 Widget 配置同一个 Team。
5. 将 `App Group` 标识与代码中的 `group.com.liuchanglin.gold-price-widget` 保持一致。
6. 运行宿主应用，在主界面填写 `AppKey` 并点击“立即刷新”。
7. 将 Widget 添加到 macOS 桌面或通知中心。

## 目录结构

- `GoldPriceWidgetApp/`: 宿主应用与刷新入口
- `GoldPriceWidgetWidget/`: Widget 时间线与展示视图
- `GoldPriceWidgetShared/`: 数据模型、缓存与 Provider
- `GoldPriceWidgetTests/`: 解析层基础测试

