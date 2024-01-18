# Tech test
## <u>DevSecOps exercise–supermarket checkout</u>

Written in the Java programming language, implement the code for a supermarket 
checkout that calculates the total price of a number of items.

In a normal supermarket, items for sale are identified using Stock Keeping Units,
or `SKUs`. In our store, we'll use individual letters of the alphabet 
(A, B, C, and so on) to represent these SKUs. Our goods are priced individually,
however, some items are multi-priced: buy **n** of them, and they'll cost you **y** instead.

For example, item `A` might cost `£0.50` individually, but this week we have
a special offer: buy three `A`s and they`ll cost you `£1.30`. 
In fact, this week`s prices are:

| Item | Unit Price |        Special Price |
|------|:----------:|---------------------:|
| A    |     50     |            3 for 130 |
| B    |     20     |             2 for 38 |
| C    |     5      | 3 for 50<sup>1</sup> | 


- This exercise will be used to gauge how you approach devsecops – the processes you use, the quality of your code and the robustness of your solution.
- **DO** use as many or as few AWS Services as you normally would when working to produce a production service
- You will require access to AWS, any required services can be configured using AWS Free Tier - https://aws.amazon.com/free/
- Once you have completed the outlined tasks below, please create a public Github account and publish a README detailing the steps you took to deploy the solution, and, if appropriate, any infrastructure-as-code (IaC) you used to configure the solution.
  - Feel free to write tests, use version control and rely on the third party libraries provided.
- **DON'T** get hung up on the specifics of the implementation
  - The problem is intentionally abstract, giving you the freedom to come up with your own unique solution.
  - This is an opportunity to demonstrate your way of working and your approach to creative problem-solving – there are no precise user requirements (aside from the specification above).


<hr/>
- (<sup>1</sup>. The price calculated for any quantity of an SKU with multiple special prices will be the cheapest combination of its special prices. For example: If you buy 5 ‘C’s you would get2   for 38 +   3 for 50. If   you buy 4   ‘C’s you would get3   for 50 + 1   for 20rather than 2   for 38 + 2   for 38.)


## Running the sample solution
- This application is built using maven and has had minimal changes to make it work spring boot 3

* Java 17 (amazon corretto distribution used locally)
* Maven (3.8.6 used in development)
* Spring boot 3.x.x

### Running the app locally 
mvn clean spring-boot:run and then go http://localhost:8080 to see the UI

### Running the tests
mvn clean test

## Exercise  
<hr/>

### Deploy the supermarket checkout java application in AWS
- Deploy the application using container or as a lambda securely in AWS using IaC
- Implement CDN caching for the application
- You have two days to come up with the solution, share the URL to the app and the github code
- Reach out to disha.2.gupta@bt.com to arrange the review 
