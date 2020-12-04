using BOOKMANAGEMENT.BAL.Interface;
using BOOKMANAGEMENT.Domain.Request.Book;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace BOOKMANAGEMENT.API.Controllers
{
    
    [ApiController]
    public class BookController : ControllerBase
    {
        private readonly IBookService bookService;

        public BookController(IBookService bookService)
        {
            this.bookService = bookService; 
        }
        [HttpGet]
        [Route("/api/book/gets")]
        public async Task<OkObjectResult> Gets()
        {
            return Ok(await bookService.Gets());
        }

        [HttpPost]
        [Route("/api/book/create")]
        public async Task<OkObjectResult> Create(CreateBookRequest request)
        {
            return Ok(await bookService.CreateBook(request));
        }

        [HttpDelete]
        [Route("/api/book/delete")]
        public async Task<OkObjectResult> Delete(DeleteBookRequest request)
        {
            return Ok(await bookService.DeleteBook(request));
        }
    }
}
