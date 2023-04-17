*** Settings ***
Library    RequestsLibrary

*** Test Cases ***

Criar usuario de teste
    Create Session   serverest    url=https://serverest.dev/#/

    ${header}    Create Dictionary    Content-Type=application/json
    
    ${response}    POST On Session    serverest   url=/usuarios    expected_status=201    headers=${header}    data={"nome": "Alberto Roberto", "email": "alberto@test1.com.br", "password": "teste", "administrador": "true"}

    ${msg}    Set Variable    ${response.json()['message']}

    Should Be Equal    ${msg}    Cadastro realizado com sucesso

Consultar usuario criado e alterar os dados do mesmo
    Create Session   serverest    url=https://serverest.dev/#/

    ${response}  GET On Session    serverest    url=/usuarios

    ${json_data}  Set Variable  ${response.json()}

    ${id}    Set Variable    ${empty}

    FOR  ${usuario}  IN  @{json_data['usuarios']}
        ${nome}  Set Variable  ${usuario['nome']}
        ${_id}  Set Variable  ${usuario['_id']}

        IF  '${nome}' == 'Alberto Roberto'
            Log    Usuario encontrado com ID: ${_id}
            ${id}    Set Variable    ${_id}
        END

    END

    ${url}    Set Variable    /usuarios/${id}

    Log To Console    Alterar os dados do usuário

    
    ${header}   Create Dictionary    Content-Type=application/json
    
    ${RESPONSE}    PUT On Session    serverest   url=${url}   expected_status=200    headers=${header}    data={"nome": "Roberto Silva", "email": "Robertos@test1.com.br", "password": "teste", "administrador": "false"}

    ${msg}    Set Variable    ${RESPONSE.json()['message']}

    Should Be Equal    ${msg}    Registro alterado com sucesso
