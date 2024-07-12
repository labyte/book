## 表格

嵌入 `Html` 自定义表格（横向拉伸，固定每列的比列，设置为excel样式等）


代码

```markdown
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
    font-size: 12px; /* 设置字体大小 */
    table-layout: fixed; /* 固定表格布局  这样可实现表格第一列固定宽度，剩下的按比例自动拉伸*/
}

.excel-table th, .excel-table td {
    border: 1px solid #d0d7de;
    padding: 8px;
    text-align: left;
}

.excel-table th {
    background-color: #f0f3f5;
    font-weight: bold;
}

.excel-table tr:nth-child(even) {
    background-color: #f9f9f9;
}

.excel-table tr:hover {
    background-color: #e9e9e9;
}

.excel-table th:nth-child(1), .excel-table td:nth-child(1) {
    width: 30%;
    /*  width: 100px; 固定第一列宽度 */
}

.excel-table th:nth-child(2), .excel-table td:nth-child(2) {
    width: 20%;
}

.excel-table th:nth-child(3), .excel-table td:nth-child(3) {
    width: 50%;
}
</style>

<div class="table-container">
    <table class="excel-table">
        <thead>
            <tr>
                <th>列1</th>
                <th>列2</th>
                <th>列3</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><a href="https://example.com">链接1</a></td>
                <td><a href="https://example.com">链接2</a></td>
                <td><a href="https://example.com">链接3</a></td>
            </tr>
            <tr>
                <td><a href="https://example.com">链接4</a></td>
                <td><a href="https://example.com">链接5</a></td>
                <td><a href="https://example.com">链接6</a></td>
            </tr>
        </tbody>
    </table>
</div>

```

效果


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
    font-size: 14px; /* 设置字体大小 */
    table-layout: fixed; /* 固定表格布局 */
}

.excel-table th, .excel-table td {
    border: 1px solid #d0d7de;
    padding: 8px;
    text-align: left;
}

.excel-table th {
    background-color: #f0f3f5;
    font-weight: bold;
}

.excel-table tr:nth-child(even) {
    background-color: #f9f9f9;
}

.excel-table tr:hover {
    background-color: #e9e9e9;
}

.excel-table th:nth-child(1), .excel-table td:nth-child(1) {
    /* width: 30%; */
      width: 100px; /*固定第一列宽度 */
}

.excel-table th:nth-child(2), .excel-table td:nth-child(2) {
    width: 40%;
}

.excel-table th:nth-child(3), .excel-table td:nth-child(3) {
    width: 60%;
}
</style>

<div class="table-container">
    <table class="excel-table">
        <thead>
            <tr>
                <th>列1(宽100)</th>
                <th>列2(宽40%)</th>
                <th>列3(宽60%)</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><a href="https://example.com">链接1</a></td>
               <td>
                   <ol>
                        <li>有序</li>
                        <li>有序</li>
                    </ol>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td>内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容</td>
                <td>
                    <ul>
                        <li>无序</li>
                        <li>无序</li>
                    </ul>
                </td>
            </tr>
        </tbody>
    </table>
</div>