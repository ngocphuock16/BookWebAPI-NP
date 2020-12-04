using BOOKMANAGEMENT.Domain.Request.Book;
using BOOKMANAGEMENT.Domain.Response.Book;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace BOOKMANAGEMENT.DAL.Interface
{
    public interface IBookRepository
    {
        Task<IEnumerable<Book>> Gets();

        Task<CreateBookResult> CreateBook(CreateBookRequest request);

        Task<DeleteBookResult> DeleteBook(DeleteBookRequest request);
    }
}
