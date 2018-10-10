# downView
类似微信的右上角下拉菜单，自动识别方向，简单易用。
## 安装
只需要将downView.h和downView.m文件拖入项目中并引用。</br>
PS：由于采用masonry布局，请保证项目中有masonry。
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
#### delegate
```objective-c
- (void)downView:(downView *)downView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"*****%ld*****",indexPath.row);
}
```

### 参数
* point：点击的坐标或者某个控件的中心点坐标
* superView：downView的父视图
* titleArray：downView每一行的标题（不可以为空）
* imageArray：downView每一样的图标（可以为空）
