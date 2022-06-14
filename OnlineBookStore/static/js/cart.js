async function load_cart() {
    let response = await fetch('/api/cart');
    let cart = await response.json();

    console.log(cart);

    // insert books into the DOM
    let cart_container = document.getElementById('cart-container');

    if (cart.size == 0) {
        let cart_article = cart_container.appendChild(document.createElement('article'));
        cart_article.classList.add('media');
        cart_article.classList.add('content-section');

        let cart_body = cart_article.appendChild(document.createElement('div'));
        cart_body.classList.add('media-body');
        let cart_empty = cart_body.appendChild(document.createElement('h3'));
        cart_empty.classList.add('article-title');
        cart_empty.innerText = 'Your Cart is Empty.';
        cart_empty.style.textAlign = 'center';
    } else {
        for (let book of cart.cart) {
            let cart_article = cart_container.appendChild(document.createElement('article'));
            cart_article.classList.add('media');
            cart_article.classList.add('content-section');

            let book_image = cart_article.appendChild(document.createElement('img'));
            book_image.classList.add('rounded-circle');
            book_image.classList.add('article-img');
            book_image.src = 'static/Book_Image/' + book.image_file;

            let book_body = cart_article.appendChild(document.createElement('div'));
            book_body.classList.add('media-body');

            let article_metadata = book_body.appendChild(document.createElement('div'));
            article_metadata.classList.add('article-metadata');

            let delete_div = article_metadata.appendChild(document.createElement('div'));
            delete_div.style.float = 'right';

            let delete_form = delete_div.appendChild(document.createElement('form'));

            let delete_button = delete_form.appendChild(document.createElement('input'));
            delete_button.classList.add('btn');
            delete_button.classList.add('btn-danger');
            delete_button.value = 'Delete';
            delete_button.type = 'submit';
            // delete via API json
            delete_button.addEventListener('click', async function() {
                let response = await fetch('/api/cart', {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        'cart_id': book.cart_id
                    })
                });
                let data = await response.json();
                if (data.status == 'OK') {
                    window.location.reload();
                }
            });

            let book_title = article_metadata.appendChild(document.createElement('h3'));
            book_title.classList.add('book-title');
            book_title.innerText = book.title;

            let book_author = article_metadata.appendChild(document.createElement('small'));
            book_author.classList.add('text-muted');
            book_author.innerText = book.author;

            let book_price = book_body.appendChild(document.createElement('p'));
            book_price.classList.add('article-content');
        };

    // add the total price
    let total_price = 0;
    for (let book of cart.cart) {
        total_price += book.price;
    };

    let cart_total_article = cart_container.appendChild(document.createElement('article'));
    cart_total_article.classList.add('media');
    cart_total_article.classList.add('content-section');

    cart_total_article.appendChild(document.createElement('h3')).innerText = 'Total\xA0:';
    cart_total_article.appendChild(document.createElement('h3')).innerText = '\xA0₱' + total_price;

    let checkout_div = cart_total_article.appendChild(document.createElement('div'));
    checkout_div.classList.add('checkout');
    let a_btn = checkout_div.appendChild(document.createElement('a'));
    a_btn.classList.add('btn');
    a_btn.classList.add('btn-success');
    a_btn.classList.add('btn-sm');
    a_btn.classList.add('mt-1')
    a_btn.classList.add('mb-1')
    a_btn.textContent = 'Check out';
    a_btn.href = '/checkout';
    a_btn.addEventListener('click', async function(){
        let response = await fetch('/api/verify_address', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        let data = await response.json();
        if (data.status == 'OK') {
            console.log('ok');
            window.location.href = '/checkout';
        } else {    // if the user hasn't set up their address yet
            console.log(data.status);
            window.location.href = '/account';
        }
    }); 

    };

}

load_cart();
