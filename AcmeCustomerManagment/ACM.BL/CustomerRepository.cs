using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace ACM.BL
{
    public class CustomerRepository
    {
        #region Constructor

        public CustomerRepository()
        {
            Customers = new List<Customer>();
            if (!m_isDbCall)
                readCustomerFromDB();
        }

        #endregion

        #region Methods

        #region Find

        public Customer Find(List<Customer> p_customerList, int p_customerId)
        {
            Customer foundCustomer;

            //var query = from c in p_customerList
            //            where c.CustomerId == p_customerId
            //            select c;

            //foundCustomer = query.FirstOrDefault();

            foundCustomer = p_customerList.Where(c =>
                                        c.CustomerId == p_customerId)
                                        .FirstOrDefault();
            return foundCustomer;
        }

        #endregion
        #region OrderCustomers

        public void OrderCustomers()
        {
            Customers = (from c in Customers
                           orderby c.LastName
                           select c).ToList();
        }

        #endregion
        #region GetNamesAndTypes

        public dynamic GetNamesAndTypes(List<Customer> p_customerList, List<CustomerType> p_customerTypeList)
        {
            var query = p_customerList.Join(p_customerTypeList,
                                        c => c.CustomerTypeId,
                                        ct => ct.CustomerTypeId,
                                        (c, ct) => new
                                        {
                                            Name = c.LastName + ", " + c.FirstName,
                                            CustomerTypeName = ct.TypeName
                                        });

            return query.ToList();
        }

        #endregion
        #region GetNamesAndID

        public dynamic GetNamesAndID(List<Customer> p_customerList)
        {
            var query = p_customerList.OrderBy(c => c.LastName)
                                            .ThenBy(c => c.FirstName)
                                            .Select(c => new
                                            {
                                                Name = c.LastName + ", " + c.FirstName,
                                                c.CustomerId
                                            });
            return query.ToList();
                                         
        }

        #endregion

        #endregion

        #region readCustomerFromDB

        private void readCustomerFromDB()
        {
            var connectionString = ConfigurationManager.AppSettings["ConnectionString"];
            var table = new DataTable(ConfigurationManager.AppSettings["Customer"]);

            using (var conn = new SqlConnection(connectionString))
            {
                //Console.WriteLine("connection created successfuly");

                string command = ConfigurationManager.AppSettings["CustomerCommand"];

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
                        Customers.Add(new Customer());
                        Customers[i].CustomerId = Convert.ToInt32(row["CustomerId"]);
                        Customers[i].LastName = row["LastName"].ToString();
                        Customers[i].FirstName = row["FirstName"].ToString();
                        Customers[i].EmailAddress = row["EmailAddress"].ToString();
                        Customers[i].CustomerTypeId = Convert.ToInt32(row["CustomerTypeId"]);
                        i++;
                    }

                    conn.Close();
                    //Console.WriteLine("connection closed successfuly");
                }
            }
        }

        #endregion

        #region Field

        public List<Customer> Customers { get; set; }
        private bool m_isDbCall = false;

        #endregion
    }
}