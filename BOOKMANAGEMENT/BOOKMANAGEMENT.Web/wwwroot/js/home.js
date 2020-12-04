var home = {} || home;


home.tbBookmn = function () {
    $.ajax({
        url: 'https://localhost:44360/api/book/gets',
        method: 'GET',
        contentType: 'JSON',
        success: function (data) {
            $.each(data, function (i, v) {
                $('#tbBook>tbody').append(`<tr>
                                            <td>${v.bookId}</td>
                                            <td>${v.bookName}</td>
                                            <td>${v.author}</td>
                                            <td>${v.description}</td>
                                            <td>${v.year}</td>
                                            <td>${v.count}</td>                                            
                                        </tr>`);
            })

        }
    });
}


home.init = function () {
    home.tbBookmn();
}

$(document).ready(function () {
    home.init();
});