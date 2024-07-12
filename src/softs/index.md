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
    width: 20%;
}
.excel-table th:nth-child(3), .excel-table td:nth-child(3) {
    width:40%;
}

.excel-table th:nth-child(4), .excel-table td:nth-child(4) {
    width: 40%;
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
                <th>图示</th>
                <th>说明</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><a href="typora.md">Typora</a></td>
                <td><iamge ref="" ></td>
                <td>MarkDown 编辑器，早期开源免费，后期开始收费</td>
            </tr>
            <tr>
                <td>2</td>
                <td><a target="_blank" href="https://xournalpp.github.io/">Xournal++</a></td>
                <td><img  src="image/index/1720776122674.png" ></td>
                <td>MarkDown 编辑器，早期开源免费，后期开始收费</td>
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
                <th>图示</th>
                <th>说明</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><a href="visual-studio.md">Visual Studio</a></td>
                <td><iamge ref="" ></td>
                <td></td>
            </tr>
            <tr>
                <td>2</td>
                <td><a href="visual-studio-code.md">Visual Studio Code</a></td>
                <td><iamge ref="" ></td>
                <td></td>
            </tr>
             <tr>
                <td>3</td>
                <td><a href="etbrains-rider.md">JetBrains Rider</a></td>
                <td><iamge ref="" ></td>
                <td></td>
            </tr>
        </tbody>
    </table>
</div>

