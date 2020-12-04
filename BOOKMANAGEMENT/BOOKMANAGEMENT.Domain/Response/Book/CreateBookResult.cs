using System;
using System.Collections.Generic;
using System.Text;

namespace BOOKMANAGEMENT.Domain.Response.Book
{
    public class CreateBookResult
    {
        public int BookId { get; set; }
        public string BookName { get; set; }
        public string Author { get; set; }
        public string Description { get; set; }

        public int Year { get; set; }
        public int Count { get; set; }
        public string Message { get; set; }
    }
}
