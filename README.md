# ZZAttributedMarkupDemo


------

> **前言**
>: **ZZAttributedMarkup是以[WPAttributedMarkup][1]为原本。因为原作者没有更新了，而我觉得这是个很好用的超小型的文字排版(CoreText)开源代码。本人只是修复了bug，整合了代码，会不断更新。我只是重新造轮子。尊重原作者，若侵即删。**


### ZZAttributedMarkup 是什么、能做什么。
**关于文字排版的有很多开源代码，其实现的主要功能是高度自定义字体样式，插入图片，添加点击事件等。**如：OHAttribtuedLabel、DTCoreText、Nimbus、M80AttributedLabel、WXLabel等。有一些开源Label大致实现方法是：继承UIView（并非直接继承UILabel）创建一个子类，为其添加text、font、textColor、shadow、textAlignment、lineBreakMode等属性，然后在`- (void)drawRect:(CGRect)rect;`方法中使用CoreText和CoreGraphics，根据设置的属性要求将文本绘制出来。优点：极大化的自定义Label，灵活功能强大。缺点：不能再使用UILabel的计算文本高度，需要手写计算方法，不能根据文本内容进行autolayout布局。总的来说就是：可能会影响某些布局，不能再使用UILabel系统提供的好方法。

**ZZAttributedMarkup**是一个简单而实用的category，你可以很方便的来用它来创建富文本，通过标签的方式设置属性字典。（类似HTML中标签中的内容、css定义的样式。）

``` HTML
// 定义样式
    <style type=text/css>
      body{
        color:red;
      }
    </style>

// 展现内容
    <body>这段字是红色的</body>
```

> <font color="red">这段字是红色的</font>


----------


### 详解与举例

 **demo中的类**

 - **NSString+AttributedMarkup**  (category，自定义字体样式，插入图片)
 - **ClickEventLabel** (继承UILabel，添加点击事件)

<center>**举个栗子**</center>
``` java
    NSDictionary *style1 = @{
                             @"body":@[[UIFont systemFontOfSize:18],[UIColor grayColor]],
                             @"bold":[UIFont boldSystemFontOfSize:22],
                             @"red": [UIColor redColor]
                             };
                             
    NSString *text1 = @"一段普通 <bold>字体</bold> <red>颜色</red> 富文本";
    
    _label1.attributedText = [text1 attributedStringWithStyleBook:style1];
```
<center>![一段普通富文本](http://upload-images.jianshu.io/upload_images/1683760-6f29169a8123c960.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)</center>

在这个例子中，与`@"bold"`关联的样式应用于`<blod>`标记的文本中包含的文本(大一点的粗体)。与`@"red"`关联的样式应用于`<red>`标记的文本中包含的文本(字设置为红色)。与`@"body"`关联的样式被应用于整个文本。(没错，如果有设置`@"body"`样式，默认会修饰全部内容)。
`NSDictionary *style1;`这个字典叫做**style book**里面包含了文本的字体、颜色等(NSAttributedString)属性诸如此类的设置。以下的这些属性可以被设置到属性字典当中:

 - **UIColor** - 给文本设置颜色
    ```
    @"red" : [UIColor redColor]
    ```

 - **UIFont** - 给文本设置字体
    ```
    @"bold" : [UIFont boldSystemFontOfSize:22]
    ```
 - **UIImage** - 插入图片到文本在文本段。**注释：图像标签内的文本必须包含一个单独的字符，这将被图像替换。** (详解代码见demo)
    ```
    @"thumb":[UIImage imageNamed:@"thumbIcon"]

    <thumb> </thumb>
    ```
    
 - **NSDictionary** - (传统方法)根据键值对给文本设置属性.这个可以用来设置**(NSAttributedString中)**下划线、中划线、段落样式等。设置样式的字典，元素是由小样式组成。
    ```
    @"line" : @{
                NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSFontAttributeName : [UIFont systemFontOfSize:18]
            }
    ```
    
 - **NSArray** - 设置样式的数组，元素是由小样式组成。
    ``` 
    @"body" : @[
                [UIFont systemFontOfSize:18],
                [UIColor grayColor]
                ],
    ```
    

 - **AttributedMarkupAction** - (存储Action block的类) **给文本添加了超链接属性** (添加点击事件)
    ```
     @"help":[AttributedMarkupAction styledActionWithAction:^{
                                              NSLog(@"Help Action");
                                              }],
    ```
    
    
    

 - **常量标签** 

    **1. bold - 默认会修饰全部内容**
    ```
    @"bold" : [UIFont boldSystemFontOfSize:22]
    <bold>修饰全部内容</bold>
    ```
    **2. link - 默认会修饰添加了超链接属性的内容**
    ```
    @"link" : [UIColor orangeColor]
    <link>修饰点击事件内容</link>
    ```
 
 **运行截图**
<center>![ZZAttributedMarkup  Simulator Screen Shot](http://upload-images.jianshu.io/upload_images/1683760-2993ea878cc0d5e6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)</center>

  [1]: https://github.com/nigelgrange/WPAttributedMarkup#wpattributedmarkup
