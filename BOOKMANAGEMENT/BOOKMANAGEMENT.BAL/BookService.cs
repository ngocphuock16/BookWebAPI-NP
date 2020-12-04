using BOOKMANAGEMENT.BAL.Interface;
using BOOKMANAGEMENT.DAL.Interface;
using BOOKMANAGEMENT.Domain.Request.Book;
using BOOKMANAGEMENT.Domain.Response.Book;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace BOOKMANAGEMENT.BAL
{
    public class BookService : IBookService
    {
        private readonly IBookRepository bookRepository;
        public BookService(IBookRepository bookRepository)
        {
            this.bookRepository = bookRepository;
        }
        public async Task<CreateBookResult> CreateBook(CreateBookRequest request)
        {
            return await bookRepository.CreateBook(request);
        }

        public async Task<DeleteBookResult> DeleteBook(DeleteBookRequest request)
        {
            return await bookRepository.DeleteBook(request);
        }

        public async Task<IEnumerable<Book>> Gets()
        {
            return await bookRepository.Gets();
        }
    }
}
