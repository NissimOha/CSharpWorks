using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ACM.BL
{
    public class CustomerTypeRepository
    {
        #region Constructor

        public CustomerTypeRepository()
        {
            CustomerType = new List<CustomerType>();
            if (!m_isDbCall)
                readCustomerTypeFromDB();
        }

        #endregion

        #region readCustomerTypeFromDB

        private void readCustomerTypeFromDB()
        {
            var connectionString = ConfigurationManager.AppSettings["ConnectionString"];
            var table = new DataTable(ConfigurationManager.AppSettings["CustomerType"]);

            using (var conn = new SqlConnection(connectionString))
            {
                //Console.WriteLine("connection created successfuly");

                string command = ConfigurationManager.AppSettings["CustomerTypeCommand"];

                using (var cmd = new SqlCommand(command, conn))
                {
                    //Console.WriteLine("command created successfuly");

                    SqlDataAdapter adapt = new SqlDataAdapter(cmd);
                    conn.Open();
                    //Console.WriteLine("connection opened successfuly");
                    adapt.Fill(table);

                    int i = 0;
                    foreach (DataRow row in table.Rows)
                    {
                        CustomerType.Add(new CustomerType());
                        CustomerType[i].CustomerTypeId = Convert.ToInt32(row["CustomerTypeId"]);
                        CustomerType[i].TypeName = row["Descripation"].ToString();
                        i++;
                    }

                    conn.Close();
                    //Console.WriteLine("connection closed successfuly");
                }
            }
        }

        #endregion

        #region Field

        private bool m_isDbCall = false;
        public List<CustomerType> CustomerType;

        #endregion
    }
}
