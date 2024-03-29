## 关于编辑器

编辑器/IDE的选择是一个经久不衰的话题。我最早接触Windows自带的*Notepad*到后来用了一段时间 *Emacs*，再到后来用 *Notepad++*， *VS*/*Eclipse*/*Intellj*/*Pycharm*/*TinnR*/*RStudio*/*TexStudio*/*Texmacs*/*UltraEdit*，再到现在用 *VSCode*/*Sublime*/*Notepad++*。作为一个非程序员，在玩弄了大大小小的编辑器/IDE以后，在无数次下载破解激活以后，我终于发现，不是我的工具不好，而是我写的代码少。但是不管怎样，我们还是选择一个好的编辑器，毕竟这是一种能极大提高生产力的工具。

下面我会讲述一些我自己使用编辑器的心得——IDE就算了，毕竟没写过几行代码，没有什么值得记录的经验。

### Notepad++

使用时间最长，研究最多的编辑器，作者是台湾人。*Notepad++*支持简体中文。我用的最多的几个特性：
#### 优点
* **支持不保存退出**，有时候我不是想要写一个什么文件，可能只是暂时记录一些的东西，等到后来才会决定写成一个文件并保存下来，*Notepad++*让我养成了这个习惯
* **列 编 辑**，按住`Alt`使用鼠标左键拖动光标，经常和取消自动换行一起使用，用于一些格式相对固定的文本的处理
* **正则表达式替换**，和列编辑一起使用，功能很强大！想系统地学习
* **清除文本格式**，这个主要是和*Word*，*Excel*一起使用
* **支持**`GBK`**编码格式和**`GBK` `UTF-8`**转换**，这个很有用，比如`.sas`格式的文件
* **读代码**，因为有语法高亮，支持的代码种类很多，我需要的基本都支持，不支持的也有配置
* **用** *运行* **开外挂**，可以在*Notepad++*里面跑*SAS*，其他的语言配置基本也类似，尚未搭建工作平台，有这个想法。
* **其他的高级功能**，像函数列表什么的好像也很有趣，尚未研究

#### 缺点
* **不支持多重选择/编辑**，好在用替换可以弥补这个缺陷
* **dw**

### Sublime Text 3

被誉为图形界面下的神级编辑器，打开确实很快，和*Notepad++*不相上下，下面讲讲他比*Notepad++*更优秀的地方

* **支持不保存退出**、**列编辑**、**正则表达式替换**，类似*Notepad++*
* **多重选择/编辑**，有些地方用替换和正则表达式替换处理会很麻烦，用Sublime的这个功能能够实现一些很酷炫的东西，具体可以看Sublime官网的动画演示
* `.json`**配置**，这一点比*Notepad++*要好，至少更有条理了，查找配置什么的都很方便
* **用** *Build* **开外挂**，提交`cmd`命令很轻松，可以允许我配置

```java
public class HelloWorld{
	public static void main(String[] args){
		System.out.println("Hello, world!");
	}
}
```

