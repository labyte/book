# Excel插件-EPPlus

1. 使用前需要设置证书声明

2. 一个文件中的sheet,索引是从0开始的

3. 表里面的内容，行和列的索引都是从1开始的

4. 当new ExcelPackage 时，若没有文件会直接创建

5. 在 wpf 和 unity 端都比较好用， unity 端可以用这个来读取配置的excel文件，转换为Unity 多序列化文件，或者 json ，注意exce只是用来配置文件，真正使用的还是json等通用的文件格式，因为excel 在有些平台不支持，或者说使用的插件不支持，且excel文件比较大，冗余数据多 


代码：

```
public static List<string[]> ReadAllInfo(int hostId)
{
    ExcelPackage.LicenseContext = LicenseContext.NonCommercial;//声明非商业证书

    FileInfo fileInfo = new FileInfo(excelPath);
    if(File.Exists(fileInfo.FullName) == false)
    {
        return null;
    }
    using (ExcelPackage ep = new ExcelPackage(fileInfo))
    {
        List<string[]> listArr = new List<string[]>();
        ExcelWorksheet ipSheet = ep.Workbook.Worksheets[hostId];
        if (ipSheet.Cells[2, 1].Value == null) return null;
        int workStaCount = int.Parse(ipSheet.Cells[2, 3].Value.ToString());
        int count = 3 + workStaCount;
        int row = 1;
        while (true)
        {
            if (ipSheet.Cells[row, 1].Value != null)
            {
                string[] rowData = new string[count];
                for (int i = 0; i < count; i++)//遍历列
                {
                    if (ipSheet.Cells[row, i + 1].Value != null)
                        rowData[i] = ipSheet.Cells[row, i + 1].Value.ToString();
                }
                listArr.Add(rowData);
                row++;
            }
            else
            {
                break;
            }
        }
        return listArr;
    }
}

```

