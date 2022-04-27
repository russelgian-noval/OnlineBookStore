async function load_books() {
    let response = await fetch('/api/books');
    let books = await response.json();

    // insert books into the DOM
    let books_container = document.getElementById('books_container');

    for (let book of books.books) {
        console.log(book);
        let book_article = books_container.appendChild(document.createElement('article'));
        book_article.classList.add('media');
        book_article.classList.add('content-section');

        let book_image = book_article.appendChild(document.createElement('img'));
        book_image.classList.add('rounded-circle');
        book_image.classList.add('article-img');
        book_image.src = 'static/Book_Image/' +book.image_file;

        let book_body = book_article.appendChild(document.createElement('div'));
        book_body.classList.add('media-body');

        let article = book_body.appendChild(document.createElement('div'));
        article.classList.add('article-metadata');
        
        let book_link = article.appendChild(document.createElement('a'));
        book_link.classList.add('mr-2');
        book_link.href = '/book_info/' + book.id;
        book_link.innerText = book.title;

        article.appendChild(document.createElement('br'));

        let book_author = article.appendChild(document.createElement('small'));
        book_author.classList.add('text-muted');
        book_author.innerHTML = book.author;

        let book_price = book_body.appendChild(document.createElement('p'));
        book_price.classList.add('article-content');
        book_price.innerHTML = '₱' + book.price;

    }
}

load_books();
