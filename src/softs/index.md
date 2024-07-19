<style>
.table-container {
    display: flex;
    justify-content: center;
    width: 100%;
}

.excel-table {
    width: 100%;
    border-collapse: collapse;
    font-family: Arial, sans-serif;
    font-size: 15px; /* 设置字体大小 */
    table-layout: fixed; /* 固定表格布局 */
}

.excel-table th, .excel-table td {
    border: 1px solid #d0d7de;
    padding: 12px;
    text-align: left;
    vertical-align: top; 
}

.excel-table th {
    background-color: #f0f3f5;
    font-weight: bold;
}

.key-cell {
    background-color: #df7400;
}

/* .excel-table tr:nth-child(even) {
    background-color: #f9f9f9;
} */
/* 禁用隔行背景色不同的功能 */
.excel-table tr:nth-child(even), table tr:nth-child(odd) {
    background-color: transparent; /* 确保所有行背景色一致 */
}

.excel-table tr:hover {
    background-color: inherit;
}


.bold-first-column {
    font-weight: bold;
}
.excel-table th:nth-child(1), .excel-table td:nth-child(1) {
    /* width: 30%; */
    width:40px;
}

.excel-table th:nth-child(2), .excel-table td:nth-child(2) {
    width: 30%;
}
.excel-table th:nth-child(3), .excel-table td:nth-child(3) {
    width:70%;
}



</style>


# 软件

## 文本编辑


<div class="table-container">
    <table class="excel-table" id="example-table">
        <thead>
            <tr>
                <th>编号</th>
                <th>软件</th>
                <th>说明</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><a href="typora.md">Typora</a></td>
                <td>MarkDown 编辑器，早期开源免费，后期开始收费</td>
            </tr>
            <tr>
                <td>2</td>
                <td><a target="_blank" href="https://xournalpp.github.io/">Xournal++</a><br><br>支持数位板<br>适合网课使用</td>
                <td><img src="image/index/1720776122674.png" ></td>
            </tr>
        </tbody>
    </table>
</div>

## 文件处理

<div class="table-container">
    <table class="excel-table" id="example-table">
        <thead>
            <tr>
                <th>编号</th>
                <th>软件</th>
                <th>说明</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><a href="https://www.bulkrenameutility.co.uk/">批量重命名工具<br>(bulkrenameutility)</a><br><br> 完全免费！！！ <br><br>命令行版本的 Bulk Rename Utiltiy (例如用于脚本)，请到我们的网站下载 Bulk Rename Command<br><br>64 位版本的 WIndows (XP/2003/Vista)，那么你将受益于 64 位版本的 Bulk Rename Utility<br><br>如果你扫描一个很大的文件夹遇到错误时想取消，请按 escape 键。 </td>
                <td>批量重命名实用程序允许您根据极其灵活的标准轻松重命名文件和整个文件夹，添加日期/时间戳、替换数字、插入文本、转换大小写、添加自动编号、处理文件夹和子文件夹......还有更多！<br><img  src="https://www.bulkrenameutility.co.uk/assets/img-bru/bru_main1.png" ></td>
            </tr>
             <tr>
                <td>2</td>
                <td><a href="https://exiftool.org/">ExifTool</a><br><br>照片元数据编辑工具<br>命令行工具<br>冷门</td>
                <td>ExifTool 是一个独立于平台的Perl 库，外加一个命令行应用程序，用于读取、写入和编辑各种 文件中的元信息。ExifTool 支持许多不同的元数据格式，包括 EXIF、 GPS、 IPTC、 XMP、 JFIF、 GeoTIFF、 ICC Profile、 Photoshop IRB、 FlashPix、 AFCP和 ID3、 Lyrics3，以及佳能、 卡西欧、 大疆 、 FLIR 、富士、 通用电气、 GoPro 、惠普 、 JVC /Victor、 柯达、 Leaf、 美能达/柯尼卡美能达、 摩托罗拉、 尼康、 任天堂、奥林巴斯/爱普生、 松下/徕卡、 宾得/朝日、 飞思、 Reconyx 、理 光、 三星、 三洋、 适马/Foveon和 索尼等品牌 的许多数码相机的制造 商说明。</td>
            </tr>
        </tbody>
    </table>
</div>

## 开发IDE

<div class="table-container">
    <table class="excel-table" id="example-table">
        <thead>
            <tr>
                <th>编号</th>
                <th>软件</th>
                <th>说明</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><a href="visual-studio.md">Visual Studio</a></td>
                <td>强大，windwos 端首选</td>
            </tr>
            <tr>
                <td>2</td>
                <td><a href="visual-studio-code.md">Visual Studio Code</a></td>
                <td>开源免费</td>
            </tr>
             <tr>
                <td>3</td>
                <td><a href="jetbrains-rider.md">JetBrains Rider</a></td>
                <td>付费，需要自己激活</td>
            </tr>
        </tbody>
    </table>
</div>

