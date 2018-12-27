# downView
类似微信的右上角下拉菜单，自动识别方向，简单易用。
## 安装
只需要将downView.h和downView.m文件拖入项目中并引用。</br>
PS：由于采用masonry布局，请保证项目中有masonry。
## 说明
项目中需要该功能，于是自己动手做了一个。

类似微信的右上角下拉菜单，自动识别方向，简单易用。

带有缩放动画，更美观。

点击视图空白处可收回视图。

可根据需求修改代码。
## 示例
![downView](https://github.com/CoolerTing/downView/blob/master/downView.gif)
## 使用

```objective-c
#import "downView.h"
```
并遵循```downViewDelegate```
在点击事件中创建对象并设置代理
```objective-c
downView *view = [downView initWithPoint:point superView:self.view titleArray:@[@"测试1",@"测试2",@"测试3"] imageArray:nil];
view.delegate = self;
```
### delegate
点击每一行的回调

```objective-c
- (void)downView:(downView *)downView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"*****%ld*****",indexPath.row);
}
```
```objective-c
- (void)beginHideDownView:(downView *)downView {
    //do something;
}
```
###全局属性设置
设置控件宽度
```objective-c
+ (void)setListWidth:(CGFloat)newWidth;
```
设置控件行高
```objective-c
+ (void)setRowHeight:(CGFloat)newHeight;
```
设置控件标题对齐方式
```objective-c
+ (void)setTextAlignment:(NSTextAlignment)alignment;
```

## 参数
* point：点击的坐标或者某个控件的中心点坐标
* superView：downView的父视图 (可以为空，为空时为keywindow)
* titleArray：downView每一行的标题（不可以为空）
* imageArray：downView每一行的图标（可以为空）
