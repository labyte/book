> Unity针对Sqlite的处理方法根据版本不同有不同的处理，在Unity2020以及之前，Unity官方没有给出自己的解决方案，但是在Unity2021之后，根据VisaulScrptApi，可以采用官方的方案来实现
## Unity2020及之前版本
### 导入DLL
见Unity中的DLL引用章节
### 使用教程
[Unity-sqlite使用教程](https://warl.top/posts/unity-sqlite/)
参照这个教程，导入相关的DLL，以及一些规定，不用使用他编写的插件，因为比较繁重，自己编写帮助类即可

帮助类脚本

```c#
using Mono.Data.Sqlite;
using System;
using System.Collections.Generic;

namespace LFrame
{
    public class SqlHelper
    {
// 注意：连接字符串 "Data Source="+文件路径
       // public static string connStr = "";// Utils.ConfigHelper.ConnectionString;

        public static string ip;

        /// <summary>
        /// 尝试连接数据库
        /// </summary>
        /// <returns></returns>
        public static bool TryConnectDB(string connStr)
        {
            using (SqliteConnection conn = new SqliteConnection(connStr))
            {
                try
                {
                    conn.Open();
                    ip = $"数据库地址:[{conn.DataSource}]";
                    conn.Close();
                    return true;
                }
                catch (System.Exception)
                {
                    return false;
                }
            }
        }

        /// <summary>
        /// 执行非查询语句，如delete、insert update等 创建表等
        /// <param name="sql"></param>
        /// <param name="sqlpars"></param>
        /// <returns></returns>
        public static int ExecuteNonQuery(string connStr,string sql, params SqliteParameter[] sqlpars)
        {
            using (SqliteConnection conn = new SqliteConnection(connStr))
            {
                conn.Open();
                using (SqliteCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    cmd.Parameters.AddRange(sqlpars);
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// 执行只查询一行、一列的数据 当添加一条数据需要返回自增字段时也使用该函数
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="sqlpars"></param>
        /// <returns></returns>
        public static object ExecuteScalar(string connStr,string sql, params SqliteParameter[] sqlpars)
        {
            using (SqliteConnection conn = new SqliteConnection(connStr))
            {
                conn.Open();
                using (SqliteCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    cmd.Parameters.AddRange(sqlpars);
                    return cmd.ExecuteScalar();
                }
            }
        }


        /// <summary>
        /// 使用事务执行多条语句
        /// </summary>
        /// <param name="sqlList"></param>
        /// <returns></returns>
        public static bool ExecuteTransaction(string connStr,List<string> sqlList)
        {
            using (SqliteConnection conn = new SqliteConnection(connStr))
            {
                conn.Open();
                using (SqliteTransaction tran = conn.BeginTransaction())
                {
                    using (SqliteCommand cmd = conn.CreateCommand())
                    {
                        cmd.Transaction = tran;
                        try
                        {
                            foreach (var sql in sqlList)
                            {
                                cmd.CommandType = System.Data.CommandType.Text;
                                cmd.CommandText = sql;
                                cmd.ExecuteNonQuery();
                            }

                            tran.Commit();//提交事务
                            return true;
                        }
                        catch (Exception)
                        {
                            tran.Rollback();
                            return false;
                        }
                    }
                }

            }
        }

        /// <summary>
        /// 查询多个数据，返回的是一个DataTable,并且该结果集是保存在本地的
        /// </summary>
        /// <param name="sql"></param>
        /// <param name="sqlpars"></param>
        /// <returns></returns>
        public static System.Data.DataTable ExecuteDataTable(string connStr,string sql, params SqliteParameter[] sqlpars)
        {
            using (SqliteConnection conn = new SqliteConnection(connStr))
            {
                conn.Open();
                using (SqliteCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    cmd.Parameters.AddRange(sqlpars);
                    SqliteDataAdapter adp = new SqliteDataAdapter(cmd);
                    System.Data.DataSet dataset = new System.Data.DataSet();
                    adp.Fill(dataset);
                    return dataset.Tables[0];
                }
            }
        }

        /// <summary>
        /// 表格是否存在
        /// </summary>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public static bool ExistTable(string connStr, string tableName)
        {
            string sql = $"SELECT COUNT(*) FROM sqlite_master where type='table' and name='{tableName}';";
            int result = System.Convert.ToInt32(ExecuteScalar(connStr, sql));
            return (result > 0);
        }



        /// <summary>
        /// 获取某类型的表的集合
        /// </summary>
        /// <returns></returns>
        public static List<string> GetTableListByType(string connStr,string tableType)
        {
            List<string> list = new List<string>();
            string sql = "select * from INFORMATION_SCHEMA.TABLES";
            System.Data.DataTable schemaTables = SqlHelper.ExecuteDataTable(connStr,sql);
            foreach (System.Data.DataRow dr in schemaTables.Rows)
            {
                string tableName = dr["TABLE_NAME"].ToString();
                if (tableName.StartsWith(tableType) && !tableName.Contains("#"))
                {
                    list.Add(tableName);
                }
            }
            return list;
        }

        /// <summary>
        /// 创建表
        /// </summary>
        /// <param name="sql">如："CREATE TABLE myTable (myId INTEGER CONSTRAINT PKeyMyId PRIMARY KEY, myName CHAR(50), myAddress CHAR(255), myBalance FLOAT)"</param>
        /// <returns></returns>
        public static int CreateTable(string connStr,string sql)
        {
            using (SqliteConnection conn = new SqliteConnection(connStr))
            {
                conn.Open();
                using (SqliteCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = sql;
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// 事务操作
        /// </summary>
        /// <param name="sqlTrans"></param>
        /// <returns></returns>
        public static bool TransactionOp(string connStr,string[] sqlTrans)
        {
            // 事务成功返回true，事务失败返回false  
            bool result = false;
            SqliteConnection cn = new SqliteConnection(connStr);
            SqliteCommand cmd = new SqliteCommand();
            SqliteTransaction transaction = null;
            try
            {
                // 打开数据库  
                if (cn.State == System.Data.ConnectionState.Closed)
                {
                    cn.Open();
                }

                // 开始事务  
                transaction = cn.BeginTransaction();
                cmd.Transaction = transaction;
                cmd.Connection = cn;

                //遍历所有的sql语句
                if (sqlTrans != null && sqlTrans.Length > 0)
                {
                    foreach (var sql in sqlTrans)
                    {
                        // 执行第一条SQL语句  
                        cmd.CommandType = System.Data.CommandType.Text;
                        cmd.CommandText = sql;
                        if (cmd.ExecuteNonQuery() < 0)
                            throw new Exception();
                    }
                }

                // 提交事务  
                transaction.Commit();
                result = true;
            }
            catch
            {
                result = false;
                // 回滚事务  
                transaction.Rollback();
            }
            finally
            {
                // 关闭数据库  
                if (cn.State == System.Data.ConnectionState.Open)
                {
                    cn.Close();
                }
                cn.Dispose();
                cmd.Dispose();
                transaction.Dispose();
            }
            return result;
        }

    }

}

```
## Unity2021及之后版本
在这个版本之后，官方已经给出了ORM框架来实现，可以自己定义实体，操作起来比较方便了。
博客园：https://www.cnblogs.com/Lulus/p/16414538.html
官网：https://docs.unity3d.com/Packages/com.unity.visualscripting@1.7/api/Unity.VisualScripting.Dependencies.Sqlite.SQLiteConnection.html

