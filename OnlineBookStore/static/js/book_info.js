async function load_book() {
    // get the book id from the url
    let book_id = window.location.pathname.split('/')[2];

    console.log(book_id);

    let response = await fetch('/api/books/' + book_id);
    let data = await response.json();

    console.log(data);

    // fill the book info
    let book_info = document.getElementById('book-info');

    let book_image = book_info.appendChild(document.createElement('img'));
    book_image.classList.add('book-img');
    // load image from static folder
    book_image.src = '/static/Book_Image/' + data.image_file;

    let book_body = book_info.appendChild(document.createElement('div'));
    book_body.classList.add('article-metadata');

    let book_metadata = book_body.appendChild(document.createElement('div'));
    book_metadata.classList.add('article-metadata');

    let book_title = book_metadata.appendChild(document.createElement('h2'));
    book_title.classList.add('book-title');
    book_title.innerHTML = data.title;

    let book_author = book_metadata.appendChild(document.createElement('h3'));
    let book_author_name = book_author.appendChild(document.createElement('small'));
    book_author_name.classList.add('text-muted');
    book_author_name.innerHTML = data.author;

    let book_price = book_body.appendChild(document.createElement('h5'));
    book_price.classList.add('article-content');
    book_price.innerHTML = '₱' + data.price;

    let book_content = book_body.appendChild(document.createElement('h5'));
    book_content.classList.add('article-content');
    book_content.innerHTML = "About the book : " ;

    let book_description = book_body.appendChild(document.createElement('p'));
    book_description.classList.add('article-content');
    book_description.innerHTML = data.content;

    let book_publisher = book_body.appendChild(document.createElement('h6'));
    book_publisher.classList.add('article-content');
    book_publisher.innerHTML = "Publication : " + data.publication;

    if (data.pieces == 0) {
        let out_of_stock = book_body.appendChild(document.createElement('h2'));
        out_of_stock.classList.add('book-title');
        out_of_stock.innerHTML = 'Out of Stock';

    } else {
        let add_to_cart = book_body.appendChild(document.createElement('div'));
        
        let a_button = add_to_cart.appendChild(document.createElement('a'));
        a_button.classList.add('btn', 'btn-success', 'btn-sm', 'mt-1', 'mb-1');
        a_button.innerHTML = 'Add to cart';
        // add to cart via API
        a_button.addEventListener('click', async function() {
            let response = await fetch('/api/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    'book_id': book_id
                })
            });
            window.location.href = '/cart';
        });
    }

}

load_book();
