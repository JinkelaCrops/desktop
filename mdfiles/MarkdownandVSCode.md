# Markdown and VS Code

Working with Markdown in Visual Studio Code can be pretty fun and there are a number of Markdown specific features that will help you be more productive.

## Markdown Preview

VS Code supports Markdown files out of the box. You just start writing Markdown text, save the file with the .md extension and then you can toggle the visualization of the editor between the code and the preview of the Markdown file; obviously, you can also open an existing Markdown file and start working with it. To switch between views you just have to press <code class="keybinding">Ctrl+Shift+V</code> in the editor. You can view the preview side-by-side ( <code class="keybinding">Ctrl+K V</code> ) with the file you are editing and see changes reflected in real-time as you edit.__Tips:__

Here is an example with a very simple file.

![Markdown Preview](file:///C:/Users/GdnmTlt/Desktop/mdfiles/Markdown_preview.png)

> **Tip:** You can also click on the icon on the top right of the preview window to switch back and forth between source and preview mode.

## Using your own CSS
By default, we use a CSS style for the preview that matches the style of VS Code. If you want to use your own CSS for theMarkdown preview, update the `"markdown.styles": []` [setting](http://code.visualstudio.com/docs/customization/userandworkspace) with the comma-separated list of URL(s) for your style sheet(s).

For instance, in the screen shot above we used a custom CSS to change the default font for the page and changed the color for the H1 title.

Here is the relevant CSS:

```css
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif
}

h1 {
    color: cornflowerblue
}
```

Use **File** > **Preferences** > **Workspace Settings** to bring up the workspace `settings.json` file and make this update:

```json
// Place your settings in this file to overwrite default and user settings.
{
    "markdown.styles": "Style.css"
}
```

## Snippets for Markdown

There are several built-in Markdown snippets included in VS Code - simply press <code class="keybinding">Ctrl+Space</code> (Trigger Suggest) and we will give you a context specific list of suggestions.

> **Tip:** You can add in your own User Defined Snippets for Markdown. Take a look at [User Defined](http://code.visualstudio.com/docs/customization/userdefinedsnippets) to find out how.

## Compiling Markdown into HTML

VS Code can integrate with Markdown compilers through our integrated [task runner](http://code.visualstudio.com/docs/editor/tasks). We can use this to compile `.md` files into `.html` files. Let's walk through compiling a simple
Markdown document.

### Step 1: Install a Markdown compiler

For this walkthrough, we will use the popular [Node.js](https://nodejs.org/) module, [marked](https://www.npmjs.com/package/marked).

```
npm install -g marked
```

> **Note:** There are many Markdown compilers to choose from beyond **marked**, such as [markdown-it](https://www.npmjs.com/package/markdown-it). Pick the one that best suits your needs and environment.

### Step 2: Create a simple MD file

Open VS Code on an empty folder and create a `sample.md` file.

> **Note:** You can open a folder with VS Code by either selecting the folder with **File** > **Open Folder...** or navigating to the folder and typing `code .` at the command line.

Place the following source code in that file:

    Hello Markdown in VS Code!
    ===============================
    
    This is a simple introduction to compiling Markdown in VS Code.
    
    Things you'll need:
    
    * [node](https://nodejs.org)
    * [marked](https://www.npmjs.com/package/marked)
    * [tasks.json](/docs/editor/tasks)
    
    ## Section Titles
    > This block quote is here for your information.

### Step 3: Create tasks.json

The next step is to set up the task configuration file `tasks.json`. To do this, open the **Command Palette** with <code class="keybinding">F1</code> and type in **Configure Task Runner**, press <code class="keybinding">Enter</code> to select it.

It will present a list of possible `tasks.json` templates to choose from. Select `Others` since we
want to run an external command.

This generate a `tasks.json` file in your workspace `.vscode` folder with the following content:

```json
{
    // See http://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "0.1.0",
    "command": "echo",
    "isShellCommand": true,
    "args": ["Hello World"],
    "showOutput":  "always"
}
```

Since we want to use **marked** to compile the Markdown file, we change the contents as follows:

```json
{
    // See http://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "0.1.0",
    "command": "marked",
    "isShellCommand": true,
    "args": ["sample.md", "-o", "sample.html"],
    "showOutput":  "always"
}
```

> **Tips:** While the sample is there to help with common configuration settings, IntelliSense is available for the `tasks.json` file as well to help you along. Use <code class="keybinding">Ctrl+Space</code> to see the available settings.

Under the covers, we interpret **marked** as an external task runner exposing exactly one task: the compiling of Markdown files into HTML files. The command we run is `marked sample.md -o sample.html`.

### Step 4: Run the Build Task

As this is the only task in the file, you can execute it by simply pressing <code class="keybinding">Ctrl+Shift+B</code>(**Run Build Task**).At this point, you should see an additional file show up in the file list `sample.html`.

The sample Markdown file did not have any compile problems, so by running the task all that happened was a corresponding
`sample.html` file was created.

## Automating Markdown compilation

Let's take things a little further and automate Markdown compilation with VS Code. We can do so with the same task runner
integration as before, but with a few modifications.

### Step 1: Install Gulp and some plug-ins

We will use [Gulp](http://gulpjs.com/) to create a task that will automate Markdown compilation. We will also
use the [gulp-markdown](https://www.npmjs.com/package/gulp-markdown) plug-in to make things a little easier.

```
npm install -g gulp gulp-markdown
```

> **Note:** gulp-markdown is a Gulp plug-in for the **marked** module we were using before. There are many other Gulp Markdown plug-ins you can use, as well as plug-ins for Grunt.

### Step 2: Create a simple Gulp task

Open VS Code on the same folder from before (contains `sample.md` and `tasks.json` under the `.vscode` folder), and create `gulpfile.js` at the root.

Place the following source code in that file:

```js
var gulp = require('gulp');
var markdown = require('gulp-markdown');

gulp.task('markdown', function() {
    return gulp.src('**/*.md')
        .pipe(markdown())
        .pipe(gulp.dest(function(f) {
   return f.base;
        }));
});

gulp.task('default', function() {
    gulp.watch('**/*.md', ['markdown']);
});
```

What is happening here?

* We are watching for changes to any Markdown file in our workspace, i.e. the current folder open in VS Code.
* We take the set of Markdown files that have changed, and run them through our Markdown compiler, i.e. `gulp-markdown`.
* We now have a set of HTML files, each named respectively after their original Markdown file. We then put these files in the same directory.

### Step 3: Modify the configuration in tasks.json for watching

To complete the tasks integration with VS Code, we will need to modify the task configuration from before to set a watch
on the default Gulp task we just created.

Your tasks configuration should now look like this:

```json
{
    "version": "0.1.0",
    "command": "gulp",
    "isShellCommand": true,
    "tasks": [
        {
   "taskName": "default",
   "isBuildCommand": true,
   "showOutput": "always",
   "isWatching": true
        }
    ]
}
```

### Step 4: Run the gulp Build Task

Again, as this is the only task in the file you can execute it by simply pressing Ctrl+Shift+B(**Run Build Task**). But this time, we've set a watch so the Status Bar should indicate that on the left-hand side.

![Task watching spinner](file:///C:/Users/GdnmTlt/Desktop/mdfiles/Markdown_taskwatching.png)

At this point, if you create and/or modify other Markdown files, you will see the respective HTML files generated and/or changes reflected on save. You can also enable [Auto Save](http://code.visualstudio.com/docs/editor/codebasics#_saveauto-save) to make things even more streamlined.

If you want to stop the watch, you can press <code class="keybinding">Ctrl+Shift+B</code> again and click **Terminate Running Task**in the message box. or you can use the **Command Palette** with <code class="keybinding">F1</code> and find the terminate command there.

## Next Steps

Read on to find out about:

* [Customization](http://code.visualstudio.com/docs/customization/overview) - Dig into additional settings such as word wrap and User Defined Snippets.
* [CSS, Less and Sass](http://code.visualstudio.com/docs/languages/css) - Want to edit your CSS? VS Code has great support for CSS, Less and Sass editing.

## Common Questions

**Q: Is there spell checking?**

**A:** Not in VS Code out of the box but there are [spell checking extensions](https://marketplace.visualstudio.com/items/seanmcbreen.Spell). Be sure to check the [VS Code Marketplace](https://marketplace.visualstudio.com/vscode) to look for useful
extensions to help with your workflow.

**Q: Does VS Code support [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)?**

**A:** We are using the [marked](https://github.com/chjj/marked) library with the `gfm` option set to [true](https://github.com/chjj/marked#gfm).

**Q: In the walkthrough above, I didn't find the Configure Task Runner command in the Command Palette?**

**A:** You may have opened a file in VS Code rather than a folder. You can open a folder by either selecting the folder with **File** > **Open Folder...** or navigating to the folder and typing `code .` at the command line.

## Additional Command line arguments

Here are optional command line arguments you can use when starting VS Code at the command line via `code`:

Argument|Description
--|--
`-h` or `--help`        |Print usage
`-v` or `--version`     |Print VS Code version (e.g. 0.10.10)
`-n` or `--new-window`  |Opens a new session of VS Code instead of restoring the previous session.
`-r` or `--reuse-window`|Forces opening a file or folder in the last active window.
`-g` or `--goto`        |When used with *file:line:column?*, opens a file at a specific line and optional column position. This argument is provided since some operating systems permit `:` in a file name.
*file*                  |Name of a file to open. If the file doesn't exist, it will be created and marked as edited. You can specify multiple files by separating each file name with a space.
*file:line:column?*     |Name of a file to open at the specified line and optional column position. You can specify multiple files in this manner, but you must use the `-g` argument (once) before using the *file:line:column?* specifier.
*folder*                |Name of a folder to open. You can specify multiple folders.
`-d` or `--diff`        |Open a file difference editor. Requires two file paths as arguments.
`--locale`              |Set the display language (locale) for the VS Code session. Supported locales are: `en-US`, `zh-TW`, `zh-CN`, `fr`, `de`, `it`, `ja`, `ko`, `ru`, `es`
`--disable-extensions`  |Disable all installed extensions. Extensions will still be visible in the `Extensions: Show Installed Extensions` dropdown but they will never be activated.
`-w` or `--wait`        |Wait for the window to be closed before returning

For both files and folders, you can use absolute or relative paths. Relative paths are relative to the current directory of the command prompt where you run `code`.

If you specify more than one file or folder at the command line, VS Code will open only a single instance.

``dwdw``

# 与 following captions 进行比较

敏捷的棕色狐狸 jump over the lazy dog. I can 吞下玻璃而不伤身体。 

## **与**接下来的 **cap**tions 进**行**比较

敏捷 **的棕色狐** 狸 jump over the lazy dog. I can 吞下玻璃而不伤身体。
The qiuck brown fox jumps over the lazy dog.

### 与 following captions 进行比较

敏捷的棕色狐狸 jump over the lazy dog. I can 吞下玻璃而不伤身体。

#### 试试这个然后 tell what is h4

敏捷的棕色狐狸 jump over the lazy dog. I can 吞下玻璃而不伤身体。

##### 试试这个然后 tell what is h5

敏捷的棕色狐狸 jump over the lazy dog. I can 吞下玻璃而不伤身体。

###### 试试这个然后 tell what is h6

敏捷的棕色狐狸 jump over the lazy dog. I can 吞下玻璃而不伤身体。

*敏捷*的棕色*狐狸 jump* over the *lazy dog*. I can 吞下玻璃*玻璃*玻璃而*不伤身体*。不伤身体！

## 测试

看看字体的兼容性

## 中文**字表**

义务教育语文课程常用**字表**本**字表**共收常用汉字**3500**个，根据它们在当代各类汉语阅读材料中的出现频率和汉字教学的需要，又分成两个**字表**。提供这样的**字表**，便于在教材编写中安排汉字教学的设计，也便于开展对汉字教学的评估。**字表**可作为第三学段识字、写字教学评价的依据。

阿啊哎哀唉埃挨癌矮艾爱碍安氨俺岸按案暗昂凹熬傲奥澳八巴叭吧拔把坝爸罢霸白百柏摆败拜班般颁斑搬板版办半伴扮瓣邦帮膀傍棒包胞宝饱保堡报抱豹暴爆卑杯悲碑北贝备背倍被辈奔本崩逼鼻比彼笔币必毕闭辟碧蔽壁避臂边编蝙鞭扁便变遍辨辩标表别宾滨冰兵丙柄饼并病拨波玻剥播脖伯驳泊勃博搏膊薄卜补捕不布步部擦猜才材财裁采彩踩菜蔡参餐残蚕惨灿仓苍舱藏操曹槽草册侧测策层叉插查茶察差拆柴缠产阐颤昌长肠尝偿常厂场畅倡唱抄超巢朝潮吵炒车扯彻撤尘臣沉陈闯衬称趁撑成呈承诚城乘惩程橙吃池驰迟持匙尺齿斥赤翅充冲虫崇抽仇绸愁筹酬丑瞅臭出初除厨础储楚处触川穿传船喘串窗床晨创吹垂锤春纯唇醇词瓷慈辞磁雌此次刺从匆葱聪丛凑粗促催脆翠村存寸措错搭达答打大呆代带待袋逮戴丹单担胆旦但诞弹淡蛋氮当挡党荡刀导岛倒蹈到盗道稻得德的灯登等邓凳瞪低堤滴迪敌笛底抵地弟帝递第颠典点电店垫淀殿雕吊钓调掉爹跌叠蝶丁叮盯钉顶订定丢东冬懂动冻洞都斗抖陡豆督毒读独堵赌杜肚度渡端短段断锻堆队对吨敦蹲盾顿多夺朵躲俄鹅额恶饿鳄恩儿而尔耳二发乏伐罚阀法帆番翻凡烦繁反返犯泛饭范贩方坊芳防妨房肪仿访纺放飞非啡菲肥废沸肺费分纷芬坟粉份奋愤粪丰风枫封疯峰锋蜂冯逢缝凤奉佛否夫肤孵弗伏扶服浮符幅福辐蝠抚府辅腐父付妇负附复赴副傅富赋腹覆该改钙盖溉概干甘杆肝赶敢感刚岗纲缸钢港高搞稿告戈哥胳鸽割歌阁革格葛隔个各给根跟更耕工弓公功攻供宫恭巩拱共贡勾沟钩狗构购够估咕姑孤菇古谷股骨鼓固故顾瓜刮挂拐怪关观官冠馆管贯惯灌罐光广归龟规硅轨鬼柜贵桂滚棍郭锅国果裹过哈孩海害含函寒韩罕喊汉汗旱杭航毫豪好号浩耗呵喝合何和河核荷盒贺褐赫鹤黑嘿痕很狠恨哼恒横衡轰哄红宏洪虹鸿侯喉猴吼后厚候乎呼忽狐胡壶湖葫糊蝴虎互户护花华哗滑化划画话桦怀淮坏欢还环缓幻唤换患荒慌皇黄煌晃灰恢挥辉徽回毁悔汇会绘惠慧昏婚浑魂混活火伙或货获祸惑霍击饥圾机肌鸡积基迹绩激及吉级即极急疾集辑籍几己挤脊计记纪忌技际剂季既济继寂寄加夹佳家嘉甲贾钾价驾架假嫁稼尖坚间肩艰兼监减剪检简碱见件建剑健舰渐践鉴键箭江姜将浆僵疆讲奖蒋匠降交郊娇浇骄胶焦礁角脚搅叫轿较教阶皆接揭街节劫杰洁结捷截竭姐解介戒届界借巾今斤金津筋仅紧锦尽劲近进晋浸禁京经茎惊晶睛精鲸井颈景警净径竞竟敬境静镜纠究九久酒旧救就舅居局菊橘举矩句巨拒具俱剧惧据距聚卷倦决绝觉掘嚼军君均菌俊峻卡开凯慨刊堪砍看康抗炕考烤靠科棵颗壳咳可渴克刻客课肯坑空孔恐控口扣枯哭苦库裤酷夸跨块快宽款狂况矿亏葵愧溃昆困扩括阔垃拉啦喇腊蜡辣来莱赖兰拦栏蓝篮览懒烂滥郎狼廊朗浪捞劳牢老乐勒雷蕾泪类累冷愣厘梨离莉犁璃黎礼李里哩理鲤力历厉立丽利励例隶粒俩连帘怜莲联廉脸练炼恋链良凉梁粮两亮辆量辽疗聊僚了料列劣烈猎裂邻林临淋磷灵玲凌铃陵羚零龄领岭令另溜刘流留硫瘤柳六龙笼隆垄拢楼漏露卢芦炉鲁陆录鹿碌路驴旅铝履律虑率绿氯滤卵乱掠略伦轮论罗萝逻螺裸洛络骆落妈麻马玛码蚂骂吗嘛埋买迈麦卖脉蛮满曼慢漫忙芒盲茫猫毛矛茅茂冒贸帽貌么没枚玫眉梅媒煤霉每美妹门闷们萌盟猛蒙孟梦弥迷谜米泌秘密蜜眠绵棉免勉面苗描秒妙庙灭民敏名明鸣命摸模膜摩磨蘑魔抹末沫陌莫漠墨默谋某母亩牡姆拇木目牧墓幕慕穆拿哪内那纳娜钠乃奶奈耐男南难囊恼脑闹呢嫩能尼泥你拟逆年念娘酿鸟尿捏您宁凝牛扭纽农浓弄奴努怒女暖挪诺哦欧偶爬帕怕拍排牌派攀盘判叛盼庞旁胖抛炮跑泡胚陪培赔佩配喷盆朋棚蓬鹏膨捧碰批披皮疲脾匹屁譬片偏篇骗漂飘瓢票拼贫频品平评凭苹屏瓶萍坡泼颇婆迫破剖扑铺葡蒲朴浦普谱七妻栖戚期欺漆齐其奇歧骑棋旗企岂启起气弃汽契砌器恰千迁牵铅谦签前钱潜浅遣欠枪腔强墙抢悄敲乔桥瞧巧切茄且窃亲侵秦琴禽勤青氢轻倾清情晴顷请庆穷丘秋蚯求球区曲驱屈躯趋取娶去趣圈全权泉拳犬劝券缺却雀确鹊裙群然燃染嚷壤让饶扰绕惹热人仁忍认任扔仍日绒荣容溶熔融柔肉如儒乳辱入软锐瑞润若弱撒洒萨塞赛三伞散桑嗓丧扫嫂色森僧杀沙纱刹砂傻啥晒山杉衫珊闪陕扇善伤商赏上尚梢烧稍少绍哨舌蛇舍设社射涉摄申伸身深神审婶肾甚渗慎升生声牲胜绳省圣盛剩尸失师诗施狮湿十什石时识实拾蚀食史使始驶士氏世市示式事侍势视试饰室是适逝释收手守首寿受兽售授瘦书抒叔枢殊疏舒输蔬熟暑署属鼠薯术束述树竖数刷耍衰摔甩帅双霜爽谁水税睡顺瞬说丝司私思斯撕死四寺似饲松耸宋送颂搜艘苏俗诉肃素速宿塑酸蒜算虽随髓岁遂碎穗孙损笋缩所索锁他它她塌塔踏胎台抬太态泰贪摊滩坛谈潭坦叹炭探碳汤唐堂塘糖躺趟涛掏逃桃陶淘萄讨套特疼腾藤梯踢啼提题蹄体替天添田甜填挑条跳贴铁厅听廷亭庭停蜓挺艇通同桐铜童统桶筒痛偷头投透突图徒涂途屠土吐兔团推腿退吞托拖脱驼妥拓唾挖哇蛙娃瓦歪外弯湾丸完玩顽挽晚碗万汪亡王网往忘旺望危威微为围违唯惟维伟伪尾纬委萎卫未位味胃谓喂慰魏温文纹闻蚊吻稳问翁窝我沃卧握乌污屋无吴吾五午伍武舞务物误悟雾夕西吸希析息牺悉惜晰稀溪锡熙嘻膝习席袭媳洗喜戏系细隙虾瞎峡狭辖霞下吓夏厦仙先纤掀鲜闲弦贤咸衔嫌显险县现线限宪陷献腺乡相香厢湘箱详祥翔享响想向巷项象像橡削消萧硝销小晓孝效校笑些歇协胁斜谐携鞋写泄泻卸屑械谢蟹心辛欣新信兴星猩刑行形型醒杏姓幸性凶兄匈胸雄熊休修羞朽秀绣袖嗅须虚需徐许序叙畜绪续蓄宣玄悬旋选穴学雪血寻巡询循训讯迅压呀鸦鸭牙芽崖哑雅亚咽烟淹延严言岩沿炎研盐颜衍掩眼演厌宴艳验焰雁燕央扬羊阳杨洋仰养氧痒样腰邀摇遥咬药要耀爷也冶野业叶页夜液一伊衣医依仪夷宜姨移遗疑乙已以矣蚁椅义亿忆艺议亦异役抑译易疫益谊逸意溢毅翼因阴音吟银引饮蚓隐印应英婴鹰迎盈营蝇赢影映硬哟拥永泳勇涌用优忧幽悠尤犹由邮油游友有又右幼诱于予余鱼娱渔愉愚与宇羽雨语玉吁育郁狱浴预域欲喻寓御裕遇愈誉豫元员园原圆袁援缘源远怨院愿曰约月岳钥悦阅跃越云匀允孕运晕韵蕴杂砸灾栽宰载再在咱暂赞脏葬遭糟早枣藻灶皂造噪燥躁则择泽责贼怎曾增赠渣扎眨炸摘宅窄债沾粘展占战站张章涨掌丈仗帐胀账障招找召兆赵照罩遮折哲者这浙针侦珍真诊枕阵振镇震争征挣睁蒸整正证郑政症之支汁芝枝知织肢脂蜘执直值职植殖止只旨址纸指趾至志制治质致智置中忠终钟肿种仲众重州舟周洲轴宙皱骤朱株珠诸猪蛛竹烛逐主煮嘱住助注贮驻柱祝著筑抓爪专砖转赚庄桩装壮状撞追准捉桌着仔兹姿资滋籽子紫字自宗综棕踪总纵走奏租足族阻组祖钻嘴最罪醉尊遵昨左作坐座做蔼隘庵鞍黯肮拗袄懊扒芭疤捌跋靶掰扳拌绊梆绑榜蚌谤磅镑苞褒雹鲍狈悖惫笨绷泵蹦匕鄙庇毙痹弊璧贬匾辫彪憋鳖瘪彬斌缤濒鬓秉禀菠舶渤跛簸哺怖埠簿睬惭沧糙厕蹭茬岔豺掺搀禅馋蝉铲猖敞钞嘲澈忱辰铛澄逞秤痴弛侈耻宠畴稠锄雏橱矗揣囱疮炊捶椿淳蠢戳绰祠赐醋簇窜篡崔摧悴粹搓撮挫瘩歹怠贷耽档叨捣祷悼蹬嘀涤缔蒂掂滇巅碘佃甸玷惦奠刁叼迭谍碟鼎董栋兜蚪逗痘睹妒镀缎兑墩盹囤钝咄哆踱垛堕舵惰跺讹娥峨蛾扼鄂愕遏噩饵贰筏矾妃匪诽吠吩氛焚忿讽敷芙拂俘袱甫斧俯脯咐缚尬丐柑竿尴秆橄赣冈肛杠羔膏糕镐疙搁蛤庚羹埂耿梗蚣躬汞苟垢沽辜雇寡卦褂乖棺逛闺瑰诡癸跪亥骇酣憨涵悍捍焊憾撼翰夯嚎皓禾烘弘弧唬沪猾徊槐宦涣焕痪凰惶蝗簧恍谎幌卉讳诲贿晦秽荤豁讥叽唧缉畸箕稽棘嫉妓祭鲫冀颊奸歼煎拣俭柬茧捡荐贱涧溅槛缰桨酱椒跤蕉侥狡绞饺矫剿缴窖酵秸睫芥诫藉襟谨荆兢靖窘揪灸玖韭臼疚拘驹鞠桔沮炬锯娟捐鹃绢眷诀倔崛爵钧骏竣咖揩楷勘坎慷糠扛亢拷铐坷苛磕蝌垦恳啃吭抠叩寇窟垮挎筷筐旷框眶盔窥魁馈坤捆廓睐婪澜揽缆榄琅榔唠姥涝烙酪垒磊肋擂棱狸漓篱吏沥俐荔栗砾痢雳镰敛粱谅晾寥嘹撩缭瞭咧琳鳞凛吝赁躏拎伶聆菱浏琉馏榴咙胧聋窿娄搂篓陋庐颅卤虏赂禄吕侣屡缕峦抡仑沦啰锣箩骡蟆馒瞒蔓莽锚卯昧媚魅氓朦檬锰咪靡眯觅缅瞄渺藐蔑皿闽悯冥铭谬馍摹茉寞沐募睦暮捺挠瑙呐馁妮匿溺腻捻撵碾聂孽拧狞柠泞钮脓疟虐懦糯殴鸥呕藕趴啪耙徘湃潘畔乓螃刨袍沛砰烹彭澎篷坯劈霹啤僻翩撇聘乒坪魄仆菩圃瀑曝柒凄祈脐崎鳍乞迄泣掐洽钳乾黔谴嵌歉呛跷锹侨憔俏峭窍翘撬怯钦芹擒寝沁卿蜻擎琼囚岖渠痊瘸冉瓤壬刃纫韧戎茸蓉榕冗揉蹂蠕汝褥蕊闰腮叁搔骚臊涩瑟鲨煞霎筛删煽擅赡裳晌捎勺奢赦呻绅沈笙甥矢屎恃拭柿嗜誓梳淑赎蜀曙恕庶墅漱蟀拴栓涮吮烁硕嗽嘶巳伺祀肆讼诵酥粟溯隋祟隧唆梭嗦琐蹋苔汰瘫痰谭檀毯棠膛倘淌烫滔誊剔屉剃涕惕恬舔迢帖彤瞳捅凸秃颓蜕褪屯豚臀驮鸵椭洼袜豌宛婉惋皖腕枉妄偎薇巍帷苇畏尉猬蔚瘟紊嗡涡蜗呜巫诬芜梧蜈侮捂鹉勿戊昔犀熄蟋徙匣侠暇馅羡镶宵潇箫霄嚣淆肖哮啸蝎邪挟懈芯锌薪馨衅腥汹锈戌墟旭恤酗婿絮轩喧癣炫绚渲靴薛勋熏旬驯汛逊殉丫押涯衙讶焉阎蜒檐砚唁谚堰殃秧鸯漾夭吆妖尧肴姚窑谣舀椰腋壹怡贻胰倚屹邑绎姻茵荫殷寅淫瘾莺樱鹦荧莹萤颖佣庸咏踊酉佑迂淤渝隅逾榆舆屿禹芋冤鸳渊猿苑粤耘陨酝哉赃凿蚤澡憎咋喳轧闸乍诈栅榨斋寨毡瞻斩盏崭辗栈绽彰樟杖昭沼肇辙蔗贞斟疹怔狰筝拯吱侄帜挚秩掷窒滞稚衷粥肘帚咒昼拄瞩蛀铸拽撰妆幢椎锥坠缀赘谆卓拙灼茁浊酌啄琢咨姊揍卒佐