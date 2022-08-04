var p_photo;

$(document).ready(function(){
    // Prepare the preview for profile picture
        $("#wizard-picture").change(function(){
            readURL(this);
        });
    });

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#wizardPicturePreview').attr('src', e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
        readFile();
    }
}

function readFile(){ 
    var file = document.querySelector('input[type=file]')['files'][0];
    var lainreader = new FileReader();
    var baseString;

    lainreader.onloadend = function () {
        baseString = lainreader.result;
        p_photo = baseString;
    };

    lainreader.readAsDataURL(file);
}


function get_data(){
    let title = document.getElementById('bookname').value;
    let author = document.getElementById('author').value;
    let publication = document.getElementById('publication').value;
    let isbn = document.getElementById('isbn').value;
    let content = document.getElementById('content').value;
    let price = document.getElementById('price').value;
    let piece = document.getElementById('piece').value;
    let image = document.getElementById('wizard-picture').files[0];  

    var book_data = {
        'title': title,
        'author': author,
        'publication': publication,
        'isbn': isbn,
        'content': content,
        'price': price,
        'piece': piece,
        'photo_image': null
    };

    if (image != null){
        book_data.photo_image = p_photo;
    } else {
        alert('Please select an image');
    };

    return book_data;
};


async function post_data (){
    let book_data = get_data();
    
    // check if the user has entered all the fields
    if (book_data.title == '' || book_data.author == '' || book_data.publication == '' || book_data.isbn == '' || book_data.content == '' || book_data.price == '' || book_data.piece == ''){
        alert('Please fill all the fields');
        return;
    } else {
        console.log(book_data);
        let response = await fetch('api/books', {
            method : 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(book_data)
        }
    );

    let data_ = await response.json();
    console.log(data_);
    if (data_.status == 'OK') {
        alert('Book Added Successfully');
        window.location.href = '/admin';
    } else {
        alert('Something went wrong');
    }
};
}

let submit = document.getElementById('submit');
submit.onclick = post_data;
