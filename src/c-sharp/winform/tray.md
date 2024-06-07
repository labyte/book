# 托盘应用开发


### 设置启动时不显示窗体

通过重写 `OnLoad` 来实现 

```
protected override void OnLoad(EventArgs e)
     {
         base.OnLoad(e);
         this.Visible = false;
         this.ShowInTaskbar = false;
     }
```

**异常**

在构造函数中添加 `this.ShowInTaskbar = false; ` 写了这句，导致窗体一直显示，出现异常

### 设置托盘图标

**注意事项**

- NotifyIcon 必须设置图标，否则不会显示
- ContextMenuStrip：作为菜单，可设置菜单勾选



```csharp
 // 创建 NotifyIcon。
         this.notifyIcon1 = new NotifyIcon();
         this.notifyIcon1.Icon = this.Icon;
         this.notifyIcon1.Visible = true;
         this.notifyIcon1.MouseDoubleClick += NotifyIcon1_MouseDoubleClick;
         // 创建 ContextMenuStrip。
         this.notifyIconMenuStrip = new ContextMenuStrip();
         // 创建并初始化 ToolStripMenuItem 对象。
         ToolStripMenuItem showFormItem = new ToolStripMenuItem("显示窗体");
         showFormItem.Click += (object? sender, EventArgs e) =>
         {
             NotifyIcon1_MouseDoubleClick(sender, null);
         };

         ToolStripMenuItem item2 = new ToolStripMenuItem("开机自启动") { CheckOnClick = true, Checked = true };
         item2.CheckedChanged += (object? sender, EventArgs e) =>
         {
             bool isAuto = ((ToolStripMenuItem)sender).Checked;
             SetAutoStart(isAuto);
         };

         ToolStripMenuItem item3 = new ToolStripMenuItem("退出");
         item3.Click += (object? sender, EventArgs e) =>
         {
             Application.Exit();  // 退出应用程序
         };
         // 将 ToolStripMenuItem 对象添加到 ContextMenuStrip 的 Items 集合中。
         this.notifyIconMenuStrip.Items.Add(showFormItem);
         this.notifyIconMenuStrip.Items.Add(item2);
         this.notifyIconMenuStrip.Items.Add(item3);
         // ContextMenu 属性设置当右键点击系统托盘图标时显示的菜单。
         notifyIcon1.ContextMenuStrip = this.notifyIconMenuStrip;
```

其他开机启动方式（不推荐）

- 拷贝快捷方式到启动菜单
- 添加任务几乎

### 设置气泡消息

- 设置消息标题
- 设置消息内容
- 设置消息图标
- 设置显示时间
- 没找到在那里更改程序集的名称，如案例中为 `TSCT` 它就显示TSCT


```csharp
notifyIcon1.BalloonTipIcon = ToolTipIcon.Info;
notifyIcon1.BalloonTipTitle = "提示";
notifyIcon1.BalloonTipText = "培训系统被控端已启动";
notifyIcon1.ShowBalloonTip(3000);
```

### 设置开机启动

**重要部分！！！**

实现向其他软件一样的可以通过界面操作设置软件是否开机启动，采用的方式为修改注册表，有几个注意事项

- 不要设置软件为管理员权限启动，这样开机启动无效
- 修改当前用户的注册表(`Registry.CurrentUser`)，不要修改本机的注册表(`Registry.LocalMachine`)，否则会要求管理员权限，从而导致启动失败


```csharp
string R_startPath = Application.ExecutablePath;
         try
         {
             RegistryKey R_currentUser = Registry.CurrentUser; //不要使用本地，本地的无法开机启动
             RegistryKey? R_run = Registry.CurrentUser.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
             if (autoStart)
             {
                 if (R_run == null)
                     R_run = Registry.CurrentUser.CreateSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
                 R_run.SetValue(Properties.Resources.RegistryKey, R_startPath);
                 R_run.Close();
                 OnMsgEventHandler(MsgType.Info, "软件设置自动启动成功！");
             }
             else
             {
                 if (R_run != null)
                 {
                     R_run.DeleteValue(Properties.Resources.RegistryKey);
                     R_run.Close();
                     OnMsgEventHandler(MsgType.Info, "软件禁止自动启动成功！");
                 }
             }
         }
         catch (Exception e)
         {
             OnMsgEventHandler(MsgType.Info, $"设置软件的开机状态：{autoStart} 出现异常！" + e.Message);
             MessageBox.Show("设置软件的开机状态异常,如那件正常启动，但是下次可能不会自动启动", "提示", MessageBoxButtons.OK, MessageBoxIcon.Error);
         }
```

### 全部代码

可能会存在其他类的引用，可自行判断

``` csharp
using System.Windows.Forms;
 public partial class Form1 : Form
 {
     private NotifyIcon notifyIcon1;

     private ContextMenuStrip notifyIconMenuStrip;
     // 右键菜单
     private ContextMenuStrip itemMenuStrip;
     public Form1()
     {
         InitializeComponent();
         InitForm();
         InitTrayIcon();
         /*
          软件每次启动，强制设置为开机启动，启动后可手动禁止开机启动
          */
         SetAutoStart(true);
     }

     private void InitForm()
     {
         OnMsgEventHandler(MsgType.Info, "软件启动");

         this.Text = Properties.Resources.AppTitle + $" V{GetVersion()}";
         this.Visible = false;
         this.StartPosition = FormStartPosition.CenterScreen;
         //this.ShowInTaskbar = false; //此语句导致窗体会显示，必须注释
         Program.OnMsgEvent += OnMsgEventHandler;
         // 初始化右键菜单
         itemMenuStrip = new ContextMenuStrip();
         ToolStripMenuItem copyMenuItem = new ToolStripMenuItem("复制");
         copyMenuItem.Click += CopyMenuItem_Click;
         itemMenuStrip.Items.Add(copyMenuItem);

         // 绑定右键菜单到ListBox
         listBox1.ContextMenuStrip = itemMenuStrip;

         listBox1.DrawMode = DrawMode.OwnerDrawVariable;
         listBox1.MeasureItem += ListBox1_MeasureItem;
         listBox1.DrawItem += listBox1_DrawItem;
         listBox1.HorizontalScrollbar = true; // 设置横向滚动条为可见
     }


     private void OnMsgEventHandler(MsgType type, string message)
     {
         MsgInfo msg = new MsgInfo() { Message = DateTime.Now.ToString("HH:mm:ss: ") + message, Type = type };
         // 判断是否需要在UI线程中执行
         if (this.InvokeRequired)
         {
             // 使用Invoke在UI线程中执行
             this.Invoke(new Action(() =>
             {
                 listBox1.DrawMode = DrawMode.OwnerDrawFixed;
                 this.listBox1.Items.Add(msg);
             }));
         }
         else
         {
             // 如果已在UI线程中，直接更新UI
             this.listBox1.Items.Add(msg);
         }
     }


     private void ListBox1_MeasureItem(object? sender, MeasureItemEventArgs e)
     {
         e.ItemHeight = (int)e.Graphics.MeasureString(listBox1.Items[e.Index].ToString(), listBox1.Font, listBox1.Width).Height;
     }

     private void listBox1_DrawItem(object? sender, DrawItemEventArgs e)
     {
         if (e.Index < 0) return;
         e.DrawBackground();
         MsgInfo info = (MsgInfo)listBox1.Items[e.Index];
         Color color = Color.White;
         switch (info.Type)
         {
             case MsgType.Error:
                 color = Color.Red;
                 break;
             case MsgType.Warning:
                 color = Color.Yellow;
                 break;
             case MsgType.Info:
                 break;
         }

         e.DrawBackground();
         //e.Graphics.DrawString(info.Message, e.Font, new SolidBrush(color), new PointF(e.Bounds.X, e.Bounds.Y));
         e.Graphics.DrawString(info.Message, e.Font, new SolidBrush(color), e.Bounds);

         // 获取文本的实际宽度，并设置为横向滚动条的最大值
         float textWidth = e.Graphics.MeasureString(info.Message, e.Font).Width;
         if (textWidth > listBox1.HorizontalExtent)
         {
             listBox1.HorizontalExtent = (int)textWidth;
         }

         e.DrawFocusRectangle();
     }


     private void button1_Click(object sender, EventArgs e)
     {
         listBox1.Items.Clear();
         listBox1.HorizontalExtent = 0;
     }

     private void button2_Click(object sender, EventArgs e)
     {
         if (listBox1.Items.Count > 10)
         {
             for (int i = listBox1.Items.Count - 10; i > -1; i--)
             {
                 listBox1.Items.RemoveAt(i);
             }
         }
         UpdateHorizontalScrollBar();
     }

     // 更新横向滚动条的宽度
     private void UpdateHorizontalScrollBar()
     {
         int maxWidth = 0;

         // 计算当前列表中最长文本的宽度
         foreach (MsgInfo item in listBox1.Items)
         {
             int itemWidth = (int)listBox1.CreateGraphics().MeasureString(item.Message, listBox1.Font).Width;
             if (itemWidth > maxWidth)
             {
                 maxWidth = itemWidth;
             }
         }

         // 将最长文本的宽度设置为横向滚动条的最大值
         if (maxWidth > listBox1.HorizontalExtent)
         {
             listBox1.HorizontalExtent = maxWidth;
         }
     }

     private void CopyMenuItem_Click(object? sender, EventArgs e)
     {
         // 获取选定项的文本
         string selectedText = "";

         foreach (var item in listBox1.SelectedItems)
         {
             selectedText += ((MsgInfo)item).Message.ToString() + Environment.NewLine;
         }

         // 将文本放入剪贴板
         Clipboard.SetText(selectedText);
     }

     private void InitTrayIcon()
     {
         // 创建 NotifyIcon。
         this.notifyIcon1 = new NotifyIcon();
         this.notifyIcon1.Icon = this.Icon;
         this.notifyIcon1.Visible = true;
         this.notifyIcon1.MouseDoubleClick += NotifyIcon1_MouseDoubleClick;
         // 创建 ContextMenuStrip。
         this.notifyIconMenuStrip = new ContextMenuStrip();
         // 创建并初始化 ToolStripMenuItem 对象。
         ToolStripMenuItem showFormItem = new ToolStripMenuItem("显示窗体");
         showFormItem.Click += (object? sender, EventArgs e) =>
         {
             NotifyIcon1_MouseDoubleClick(sender, null);
         };

         ToolStripMenuItem item2 = new ToolStripMenuItem("开机自启动") { CheckOnClick = true, Checked = true };
         item2.CheckedChanged += (object? sender, EventArgs e) =>
         {
             bool isAuto = ((ToolStripMenuItem)sender).Checked;
             SetAutoStart(isAuto);
         };

         ToolStripMenuItem item3 = new ToolStripMenuItem("退出");
         item3.Click += (object? sender, EventArgs e) =>
         {
             Application.Exit();  // 退出应用程序
         };
         // 将 ToolStripMenuItem 对象添加到 ContextMenuStrip 的 Items 集合中。
         this.notifyIconMenuStrip.Items.Add(showFormItem);
         this.notifyIconMenuStrip.Items.Add(item2);
         this.notifyIconMenuStrip.Items.Add(item3);
         // ContextMenu 属性设置当右键点击系统托盘图标时显示的菜单。
         notifyIcon1.ContextMenuStrip = this.notifyIconMenuStrip;
         ShowStartInfo();
     }

     private void NotifyIcon1_MouseDoubleClick(object? sender, MouseEventArgs e)
     {
         this.ShowInTaskbar = true;
         this.Show();  // 显示窗体
         this.WindowState = FormWindowState.Normal;  // 恢复窗体正常大小
     }
     private void UpdateNoticyIconText(bool isAutoStart)
     {
         string yes = isAutoStart ? "是" : "否";
         this.notifyIcon1.Text = $"{Properties.Resources.AppTitle}\n端口：{Program.port}\n开机启动：{yes}";
     }

     private void ShowStartInfo()
     {
         notifyIcon1.BalloonTipIcon = ToolTipIcon.Info;
         notifyIcon1.BalloonTipTitle = "提示";
         notifyIcon1.BalloonTipText = "培训系统被控端已启动";
         notifyIcon1.ShowBalloonTip(3000);
     }

     protected override void OnLoad(EventArgs e)
     {
         base.OnLoad(e);
         this.Visible = false;
         this.ShowInTaskbar = false;
     }

     protected override void OnFormClosing(FormClosingEventArgs e)
     {
         if (e.CloseReason == CloseReason.UserClosing)
         {
             e.Cancel = true;  // 取消关闭窗体
             this.Hide();  // 隐藏窗体
         }
     }


     //开机启动
     private void SetAutoStart(bool autoStart)
     {
         string R_startPath = Application.ExecutablePath;
         try
         {
             RegistryKey R_currentUser = Registry.CurrentUser; //不要使用本地，本地的无法开机启动
             RegistryKey? R_run = Registry.CurrentUser.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
             if (autoStart)
             {
                 if (R_run == null)
                     R_run = Registry.CurrentUser.CreateSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", true);
                 R_run.SetValue(Properties.Resources.RegistryKey, R_startPath);
                 R_run.Close();
                 OnMsgEventHandler(MsgType.Info, "软件设置自动启动成功！");
             }
             else
             {
                 if (R_run != null)
                 {
                     R_run.DeleteValue(Properties.Resources.RegistryKey);
                     R_run.Close();
                     OnMsgEventHandler(MsgType.Info, "软件禁止自动启动成功！");
                 }
             }
         }
         catch (Exception e)
         {
             OnMsgEventHandler(MsgType.Info, $"设置软件的开机状态：{autoStart} 出现异常！" + e.Message);
             MessageBox.Show("设置软件的开机状态异常,如那件正常启动，但是下次可能不会自动启动", "提示", MessageBoxButtons.OK, MessageBoxIcon.Error);
         }
         UpdateNoticyIconText(autoStart);
     }

     private string GetVersion()
     {
         return Assembly.GetExecutingAssembly().GetName().Version.ToString();
     }
 }
```