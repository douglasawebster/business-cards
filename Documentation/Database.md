# Database Architecture

```json 
{
    "users" : {
        "user-id" : {
            "private" : {
                "wallet" : "wallet-id"
            },
            "public" : {
                "name" : {
                    "firstName" : "Douglas",
                    "lastName" : "Webster"
                },
                "cards" : {
                    "card-id" : true
                } 
            }
        }
    },

    "cards" : {
        "card-id" : {
            "userId" : "user-id", 
            "firstName" : "Douglas",
            "middleName" : "Alan",
            "lastName" : "Webster",
            "companyName" : "Apple",
            "position" : "Software Developer",
            "address" : "123 Apple Park",
            "phoneNumber" : "123-456-7890",
            "fax" : "123-456-7890",
            "email" : "apple@gmail.com",
            "websiteURL" : "www.apple.com",
            "logoId" : "logo-id"
        }
    },

    "wallets" : {
        "wallet-id" : {
            "userId" : "user-id",
            "cards" : {
                "card-id" : {
                    "tags" : {
                        "tag-id" : true
                    }
                }
            },
            "tagSets" : {
                "tag-set-id" : true
            }
        }
    },

    "tagSets" : {
        "tag-set-id" : {
            "walletId" : "wallet-id",
            "cards" : {
                "card-id" : "tag-id"
            },
            "tags" : {
                "tag-id" : {
                    "tagName" : "Lawyers"
                }
            }
        }  
    },

    "logos" : {
        "logo-id" : {
            "logo" : "IMAGE"
        }
    }

}
```