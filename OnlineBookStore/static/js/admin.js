async function load_books(){
    let response = await fetch('/api/books');
    let books = await response.json();

    let books_container = document.getElementById('books_container');

    for (let book of books.books) {
        let article = books_container.appendChild(document.createElement('article'));
        article.classList.add('media');
        article.classList.add('content-section');

        let book_image = article.appendChild(document.createElement('img'));
        book_image.classList.add('rounded-circle');
        book_image.classList.add('article-img');
        book_image.src = 'static/Book_Image/' +book.image_file;

        let book_body = article.appendChild(document.createElement('div'));
        book_body.classList.add('media-body');
        
        let metadata = book_body.appendChild(document.createElement('div'));
        metadata.classList.add('article-metadata');

        let btn_div = metadata.appendChild(document.createElement('div'));
        btn_div.style.float = 'right';

        let update_btn = btn_div.appendChild(document.createElement('a'));
        update_btn.classList.add('btn');
        update_btn.classList.add('btn-success');
        update_btn.classList.add('btn-sm');
        update_btn.classList.add('mt-1');
        update_btn.classList.add('mb-1');
        update_btn.href = '/update_book/' + book.id;
        update_btn.innerText = 'Update';

        let delete_btn = btn_div.appendChild(document.createElement('a'));
        delete_btn.classList.add('btn');
        delete_btn.classList.add('btn-danger');
        delete_btn.classList.add('btn-sm');
        delete_btn.classList.add('mt-1');
        delete_btn.classList.add('mb-1');
        delete_btn.href = '/delete_book/' + book.id;
        delete_btn.innerText = 'Delete';

        let book_title = metadata.appendChild(document.createElement('h3'));
        book_title.classList.add('book-title');
        book_title.innerText = book.title;

        let book_author = metadata.appendChild(document.createElement('small'));
        book_author.classList.add('text-muted');
        book_author.innerHTML = book.author;

        let book_price = book_body.appendChild(document.createElement('p'));
        book_price.classList.add('article-content');
        book_price.innerHTML = '₱' + book.price;
        
    }
};

load_books();

async function load_books(){
    let response = await fetch('/api/books');
    let books = await response.json();

    let books_container = document.getElementById('books_container');

    for (let book of books.books) {
        let article = books_container.appendChild(document.createElement('article'));
        article.classList.add('media');
        article.classList.add('content-section');

        let book_image = article.appendChild(document.createElement('img'));
        book_image.classList.add('rounded-circle');
        book_image.classList.add('article-img');
        book_image.src = 'static/Book_Image/' +book.image_file;

        let book_body = article.appendChild(document.createElement('div'));
        book_body.classList.add('media-body');
        
        let metadata = book_body.appendChild(document.createElement('div'));
        metadata.classList.add('article-metadata');

        let btn_div = metadata.appendChild(document.createElement('div'));
        btn_div.style.float = 'right';

        let update_btn = btn_div.appendChild(document.createElement('a'));
        update_btn.classList.add('btn');
        update_btn.classList.add('btn-success');
        update_btn.classList.add('btn-sm');
        update_btn.classList.add('mt-1');
        update_btn.classList.add('mb-1');
        update_btn.href = '/update_book/' + book.id;
        update_btn.innerText = 'Update';

        let delete_btn = btn_div.appendChild(document.createElement('a'));
        delete_btn.classList.add('btn');
        delete_btn.classList.add('btn-danger');
        delete_btn.classList.add('btn-sm');
        delete_btn.classList.add('mt-1');
        delete_btn.classList.add('mb-1');
        delete_btn.href = '/delete_book/' + book.id;
        delete_btn.innerText = 'Delete';

        let book_title = metadata.appendChild(document.createElement('h3'));
        book_title.classList.add('book-title');
        book_title.innerText = book.title;

        let book_author = metadata.appendChild(document.createElement('small'));
        book_author.classList.add('text-muted');
        book_author.innerHTML = book.author;

        let book_price = book_body.appendChild(document.createElement('p'));
        book_price.classList.add('article-content');
        book_price.innerHTML = '₱' + book.price;
        
    }
};

load_books();

async function load_books(){
    let response = await fetch('/api/books');
    let books = await response.json();

    let books_container = document.getElementById('books_container');

    for (let book of books.books) {
        let article = books_container.appendChild(document.createElement('article'));
        article.classList.add('media');
        article.classList.add('content-section');
        article.id = 'book_' + book.id;

        let book_image = article.appendChild(document.createElement('img'));
        book_image.classList.add('rounded-circle');
        book_image.classList.add('article-img');
        book_image.src = 'static/Book_Image/' +book.image_file;

        let book_body = article.appendChild(document.createElement('div'));
        book_body.classList.add('media-body');
        
        let metadata = book_body.appendChild(document.createElement('div'));
        metadata.classList.add('article-metadata');

        let btn_div = metadata.appendChild(document.createElement('div'));
        btn_div.style.float = 'right';

        let update_btn = btn_div.appendChild(document.createElement('a'));
        update_btn.classList.add('btn');
        update_btn.classList.add('btn-success');
        update_btn.classList.add('btn-sm');
        update_btn.classList.add('mt-1');
        update_btn.classList.add('mb-1');
        update_btn.href = '/update_book/' + book.id;
        update_btn.innerText = 'Update';

        let delete_btn = btn_div.appendChild(document.createElement('a'));
        delete_btn.classList.add('btn');
        delete_btn.classList.add('btn-danger');
        delete_btn.classList.add('btn-sm');
        delete_btn.classList.add('mt-1');
        delete_btn.classList.add('mb-1');
        // delete_btn.href = '/delete_book/' + book.id;
        delete_btn.innerText = 'Delete';
        // add function to delete button using api
        delete_btn.addEventListener('click', async function(e){
            let response = await fetch('/api/books/' + book.id, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            let result = await response.json();
            if (result.status == 'OK'){
                alert('Book deleted successfully');
                // reload the page
                window.location.reload();
            } else {
                alert('Error');
            }
        });

        let book_title = metadata.appendChild(document.createElement('h3'));
        book_title.classList.add('book-title');
        book_title.innerText = book.title;

        let book_author = metadata.appendChild(document.createElement('small'));
        book_author.classList.add('text-muted');
        book_author.innerHTML = book.author;

        let book_price = book_body.appendChild(document.createElement('p'));
        book_price.classList.add('article-content');
        book_price.innerHTML = '₱' + book.price;
        
    }
};

load_books();
