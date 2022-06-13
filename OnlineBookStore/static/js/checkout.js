let load_books = async function () {
    let response = await fetch('/api/cart');
    let data = await response.json();

    let book_container = document.getElementById('book-container');
    let sum = 0;

    // check if cart is empty
    if (data.size == 0) {
        // redirect to home page
        window.location.href = "/cart";
    };

    for (let book of data.cart) {
        let article = book_container.appendChild(document.createElement('article'));
        article.classList.add('media');
        article.classList.add('content-section');

        let image = article.appendChild(document.createElement('img'));
        image.classList.add('rounded-circle');
        image.classList.add('article-img');
        image.src = 'static/Book_Image/' + book.image_file;

        let body = article.appendChild(document.createElement('div'));
        body.classList.add('media-body');

        let metadata = body.appendChild(document.createElement('div'));
        metadata.classList.add('article-metadata');

        let title = metadata.appendChild(document.createElement('h3'));
        title.classList.add('book-title');
        title.innerText = book.title;

        let author = metadata.appendChild(document.createElement('small'));
        author.classList.add('text-muted');
        author.innerText = book.author;

        let price = body.appendChild(document.createElement('p'));
        price.classList.add('article-content');
        price.innerText = '₱' + book.price;

        sum = sum + book.price;
    }

    let total_price = document.getElementById('price');
    total_price.innerText = '\xA0₱' + sum;
}

load_books();

// Post checkout data to the server
let confirm = document.getElementById('confirm');
confirm.addEventListener('click', async function () {
    let response = await fetch('/api/order', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            'message': 'Confirm'
        })
    });
    let data = await response.json();
    console.log(data);
    if (data.status == 'OK') {
        window.location.href = '/order';
    }
});
