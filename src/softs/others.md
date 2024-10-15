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


## 播放器

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
                <td><a href="https://potplayer.daum.net">视频播放器：potplayer</a></td>
                <td>外网访问</td>
            </tr>
             <tr>
                <td>2</td>
                <td><a href="https://obsproject.com">录屏软件：OBS Studio</a></td>
                <td>开源，免费，可选择录屏来源，如某个程序，下载时有点慢，可以在群晖上下载</td>
            </tr>
        </tbody>
    </table>
</div>