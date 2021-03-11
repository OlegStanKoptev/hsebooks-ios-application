//
//  MockBooksLoader.swift
//  BookExchange
//
//  Created by Oleg Koptev on 26.01.2021.
//

import Foundation

class MockBooksLoader: BooksLoading {
    func load(_ handler: @escaping ([BookBase_deprecated]) -> Void) {
        let books = try? JSONDecoder().decode([BookBase_deprecated].self, from: data)
        handler(books ?? [])
    }
    
    let data = """
    [
        {
            "id": 1,
            "author": "George Orwell",
            "language": "ENG",
            "title": "1984",
            "numberOfPages": 336,
            "publishYear": 2008,
            "pictureUrl": "https://wordery.com/jackets/00972881/1984-george-orwell-9780141036144.jpg?width=246",
            "wishers": [],
            "genres": [
                2,
                3,
                4
            ],
            "rating": 5.0
        },
        {
            "id": 2,
            "author": "Ray Bradbury",
            "language": "ENG",
            "title": "Fahrenheit 451",
            "numberOfPages": 192,
            "publishYear": 1993,
            "pictureUrl": "https://images-na.ssl-images-amazon.com/images/I/91EN22C1rbL.jpg",
            "wishers": [],
            "genres": [
                2,
                3
            ],
            "rating": 5.0
        },
        {
            "id": 3,
            "author": "Lem Stanislaw",
            "language": "ENG",
            "title": "Solaris",
            "numberOfPages": 224,
            "publishYear": 2016,
            "pictureUrl": "https://i.pinimg.com/originals/f0/6d/76/f06d762d60ea1d59c09da6dcbde0475e.jpg",
            "wishers": [],
            "genres": [
                2
            ],
            "rating": 5.0
        },
        {
            "id": 4,
            "author": "Jules Verne",
            "language": "ENG",
            "title": "Journey to the Centre of the Earth",
            "numberOfPages": 208,
            "publishYear": 1996,
            "pictureUrl": "https://wendyvancamp.files.wordpress.com/2016/04/journey-to-the-center-of-the-earth-book-cover.jpg",
            "wishers": [],
            "genres": [
                2
            ],
            "rating": 5.0
        },
        {
            "id": 5,
            "author": "Richard Osman",
            "language": "ENG",
            "title": "The Thursday Murder Club",
            "numberOfPages": 400,
            "publishYear": 2020,
            "pictureUrl": "https://images-na.ssl-images-amazon.com/images/I/81uHYq+cvkL.jpg",
            "wishers": [],
            "genres": [
                4
            ],
            "rating": 5.0
        },
        {
            "id": 6,
            "author": "J. R. R. Tolkien",
            "language": "ENG",
            "title": "The Fall of Gondolin",
            "numberOfPages": 304,
            "publishYear": 2020,
            "pictureUrl": "https://cdn.shazoo.ru/252606_Yz9lbcNDVW_fall_of_gondolin.jpg",
            "wishers": [],
            "genres": [
                5
            ],
            "rating": 5.0
        },
        {
            "id": 7,
            "author": "Andrzej Sapkowski",
            "language": "ENG",
            "title": "The Last Wish",
            "numberOfPages": 304,
            "publishYear": 2020,
            "pictureUrl": "https://www.hachettebookgroup.com/wp-content/uploads/2019/09/9780316497541-1.jpg?fit=424%2C675",
            "wishers": [],
            "genres": [
                5
            ],
            "rating": 5.0
        },
        {
            "id": 8,
            "author": "Oleg Popov",
            "language": "RU",
            "title": "Cycle 0",
            "numberOfPages": 1000,
            "publishYear": 2020,
            "pictureUrl": "https://shadycharacters.co.uk/wp/wp-content/uploads/2016/12/Book_IMG_1754-1-e1481474081467.jpg",
            "wishers": [
                5
            ],
            "genres": [
                1
            ],
            "rating": 5.0
        }
    ]
    """.data(using: .utf8)!
}
