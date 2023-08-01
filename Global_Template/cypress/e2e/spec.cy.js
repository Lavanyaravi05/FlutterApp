{/* File: 

     
    
    Objective:The objective of this page is to detail out the unit testing of Natopnal Holiday
    Description: this page is used to test all the function Success flow and failure flow
  

Initiated By: Sathya Sree G on 29th August...

 Modification History

-------------------------------------------------------------------------------------------------------------------

	DATE    |   	AUTHOR   	      |  	ModifiCation Request 	      		         |      Remarks / Details of Changes

--------------------------------------------------------------------------------------------------------------------

29-Aug-2022  	 Sathya Sree G    Sathya Sree G on 29th Aug 2022...              Initial creation


--------------------------------------------------------------------------------------------------------------------

*/}


describe('My First Test', () => {
  it('Its working!', () => {
    expect(true).to.equal(true)
  })
})

describe('My Second Test', () => {
  it('VISIT PAGE', () => {
     cy.visit(' http://192.168.76.21:11211/')

/////////////////////////////////////////////////////////////////////////////////////////////////////////

//seq 

//sequence icon

cy.get("#sequence").click()
cy.wait(1500)

//sequence add pop

cy.get("#addseq").click()
cy.wait(1500)


//seq add submit button

cy.get("#sub").click()
cy.wait(3500)

//seq add cancel button

cy.get("#canc").click()
cy.wait(1500)


//sequence add pop

 cy.get("#addseq").click()
 cy.wait(1500)

 //sequence add Active sequence

 cy.get("#activesequence").click()
 cy.wait(1500)
 cy.contains("False").click()



 //sequence add title

 cy.get("#tx_view_id").click()
 cy.get("li.MuiMenuItem-root:nth-child(1)").click()
 cy.wait(1500)


 //sequence add id type

 cy.get("#fieldname").click()
 cy.contains("Document Id").click()
 cy.wait(1500)


 //sequence add prefix

 cy.get("#prefix").type("GJODA")
 cy.wait(1500)

  //sequence add description

  cy.get("#description").type("be")
  cy.wait(1500)

  cy.get("#prefix").clear()
  cy.wait(1500)

  cy.get("#prefix").type("GJOD-")
  cy.wait(1500)

  cy.get("#description").clear()
  cy.wait(1500)

  cy.get("#description").type("ve")
  cy.wait(1500)
  
 //sequence add prefix

 cy.get("#prefix").clear()
  cy.wait(1500)

 cy.get("#prefix").type("GJODA")
 cy.wait(1500)

  //sequence add description

  
  cy.get("#description").clear()
  cy.wait(1500)

  cy.get("#description").type("be")
  cy.wait(1500)

  cy.get("#prefix").clear()
  cy.wait(1500)

  cy.get("#prefix").type("PG-")
  cy.wait(1500)


 
 //sequence add no of  digits

 cy.get("#zeropadding").type("100")
 cy.wait(1500)

 
 //sequence add last no

 cy.get("#lastno").type("@")
 cy.wait(1500)

 cy.get("#zeropadding").clear()
 cy.wait(1500)

 cy.get("#zeropadding").type("1")
 cy.wait(1500)

 cy.get("#lastno").clear()
 cy.wait(1500)

 cy.get("#lastno").type("100")
 cy.wait(1500)

//seq add submit button

 cy.get("#sub").click()
 cy.wait(3500)

 //seq edit

  //sequence edit pop

  cy.contains("PG-").click()

  cy.get("#editseq").click()
  cy.wait(1500)

  
    //sequence edit cancel button

    cy.get("#cancedt").click()
    cy.wait(1500)

   //sequence edit pop

    cy.get("#editseq").click()
    cy.wait(1500)

    //sequence edit Active sequence

    cy.get("#activesequence").click()
    cy.wait(1500)
    cy.get("#F").click()



    //sequence edit prefix

    cy.get("#prefix").clear()
    cy.wait(1500)

    cy.get("#prefix").type("VRS--")
    cy.wait(1500)

    //sequence edit description

    cy.get("#description").clear()
    cy.wait(1500)

    cy.get("#description").type("new")
    cy.wait(1500)

    cy.get("#prefix").clear()
    cy.wait(1500)

    cy.get("#prefix").type("VRSG-")
    cy.wait(1500)


    

    //sequence edit prefix

    cy.get("#prefix").clear()
    cy.wait(1500)

    cy.get("#prefix").type("VRS--")
    cy.wait(1500)

    //sequence edit description

    cy.get("#description").clear()
    cy.wait(1500)

    cy.get("#description").type("new")
    cy.wait(1500)

    cy.get("#prefix").clear()
    cy.wait(1500)

    cy.get("#prefix").type("VR-")
    cy.wait(1500)


    
   //sequence edit  no of digits

   //sequence edit last no

   cy.get("#zeropadding").clear()
    cy.wait(1500)
    
    cy.get("#zeropadding").type("100")
    cy.wait(1500)


   cy.get("#lastno").clear()
   cy.wait(1500)

   cy.get("#lastno").type("AS")
   cy.wait(1500)

    cy.get("#zeropadding").clear()
    cy.wait(1500)
    
    cy.get("#zeropadding").type("10")
    cy.wait(1500)

    
    //sequence edit last no

    cy.get("#lastno").clear()
    cy.wait(1500)

    cy.get("#lastno").type("96")
    cy.wait(1500)

   
    //seq edit submit button

    cy.get("#subedt").click()
    cy.wait(1500)

    //seq close button

    cy.get("#cancel").click()
    cy.wait(1500)
///////////////////////seq page end

///master page add

  //Add Pop icon

  cy.get("#add").click()
  cy.wait(1500)


  //master page del
  cy.get('.ag-center-cols-container > div:nth-child(1)').click()
  

  cy.get("#delete").click()
  cy.wait(1500)

  


  //master page download

  cy.get("#download").click()
  cy.wait(1500)

//////master page end


//master page routing


cy.get('.ag-center-cols-container > div:nth-child(1)').click()
cy.wait(3000)

cy.get("#detailpage").click()
cy.wait(2000)

//detail page
//add
cy.get("#add1").click()
cy.wait(1000)


//detail add submit button

cy.get("#submit").click()
cy.wait(3500)


//detail add cancel button

cy.get("#cancel").click()
cy.wait(3500)


cy.get("#add1").click()
cy.wait(1000)

//document date

cy.get("#nhdate").type("2020-02-20")
cy.wait(1500)

//reason
cy.get("#reason").type("Fever")
cy.wait(1500)

//holiday category


cy.get("#holcate").click()
cy.wait(1500)
cy.get("#nh").click()

cy.wait(1500)




//subject

cy.get("#mui-component-select-band").click()
cy.wait(1500)
cy.contains("LABOUR").click()
cy.wait(1500)

//notes

cy.get("#notes").type("new")
cy.wait(1500)

//submit

cy.get("#submit").click()
cy.wait(3500)

//edit detail page

 //detail page chkbox with  edit icon

 cy.get('.ag-center-cols-container > div:nth-child(1)').click()
 cy.get("#edit").click()
 cy.wait(500)

 //document date

 cy.get("#nhdate").type("2020-02-25")
cy.wait(1500)

//reason
cy.get("#reason").clear()
cy.wait(1500)

cy.get("#reason").type("Fever")
cy.wait(1500)

//holiday category


cy.get("#holcates").click()
cy.wait(1500)
cy.get("#OH").click()

cy.wait(1500)



//subject

cy.get("#mui-component-select-band").click()
cy.wait(1500)
cy.contains("estaff").click()
cy.wait(1500)



//notes

cy.get("#notes").clear()
cy.wait(1500)

cy.get("#notes").type("aah")
cy.wait(3000)

//submit
cy.get("#submit").click()
cy.wait(2000)


//save 

////////////////////////////////////--------detail page save

    
cy.contains("Fever").type('Cough{enter}')
cy.wait(1500)

cy.contains("aah").type('new{enter}')
cy.wait(1500)

cy.get("#save").click()
cy.wait(1500)




//detail page delete 

cy.get('.ag-center-cols-container > div:nth-child(1)').click()

cy.wait(1500)

cy.get("#delete").click()
cy.wait(1500)





//detail page download

cy.get("#download").click()
 cy.wait(1500)

//routing to Master page

 cy.get("#back").click()
 cy.wait(1500)
 


















  })
})




