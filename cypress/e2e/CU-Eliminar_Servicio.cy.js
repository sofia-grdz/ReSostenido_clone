describe('Eliminar Servicio', () => {
  before(() => {
    // Realizar la visita al sitio solo una vez al comienzo de la prueba
    cy.visit('localhost:3000/login')
    cy.get('#email').type('adrianvargasuson@gmail.com', { force: true })
    cy.get('#contrasenia').type('TacosDeGansito', { force: true })
    cy.get('#login').click()
  })

  it('Menú de navegación y click en servicios', () => {
    // Menu de navegación
    cy.get('.navbar-toggler-icon').click()
    
    // Sección de servicios
    cy.get(':nth-child(1) > :nth-child(2) > .nav-link > .d-flex').should('be.visible').click();

    // Encontrar y hacer clic en el botón deseado
    cy.contains('Floyd Rose').parent().find('button[type="submit"]').should('be.visible').click({force:true});

    //Espera
    cy.wait(2000);
    
    //Verificar el servicio inahibilitado
    //cy.contains('Servicios inactivos').next().contains('Floyd Rose').should('be.visible');

    //Espera
    cy.wait(10000);

    //Habilitar de nuevo el servicio
    cy.contains('Floyd Rose').parent().find('button[type="submit"]').click({force:true});
  })
})
