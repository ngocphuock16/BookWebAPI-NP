using System;
using System.Collections.Generic;
using System.Text;

namespace BOOKMANAGEMENT.Domain.Response.Book
{
    public class DeleteBookResult
    {
        public int BookId { get; set; }
        public string Message { get; set; }
    }
}
