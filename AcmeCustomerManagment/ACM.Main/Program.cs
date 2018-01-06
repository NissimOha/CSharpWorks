using ACM.BL;
using System;

namespace SqlTest_CSharp
{
    class Program
    {
        static void Main(string[] args)
        {
            CustomerRepository cRep = new CustomerRepository();
            CustomerTypeRepository ctRep = new CustomerTypeRepository();

            Console.WriteLine("\n********** Customers **********\n");

            foreach (var customer in cRep.Customers)
            {
                Console.WriteLine(customer.CustomerId + " " + customer.LastName + 
                                    " " + customer.FirstName + " " + customer.EmailAddress);
            }

            Console.WriteLine("\n********** CustomersByOrder **********\n");

            cRep.OrderCustomers();
            foreach (var customer in cRep.Customers)
            {
                Console.WriteLine(customer.CustomerId + " " + customer.LastName +
                                    " " + customer.FirstName + " " + customer.EmailAddress);
            }

            Console.WriteLine("\n********** CustomersName&Type **********\n");

            var query = cRep.GetNamesAndTypes(cRep.Customers, ctRep.CustomerType);

            foreach(var customer in query)
            {
                Console.WriteLine(customer);
            }
        }
    }
}
