*** Settings ***
Resource        ../resources/import.robot
Test Teardown    Close website


*** Keywords ***
create testing vaiable
    ${index}    Set Variable    1
    Set Test Variable    ${index}

Open website
    Open Browser    ${todo-web}    ${browser}    executable_path=${chrome-driver-path}
Close website
    Close Browser
Go to add item
    Click element    ${add-item-name}
Go to todo tasks
    Click element    ${to-do-tasks-name}
Go to completed task
    Click element    ${completed-name}

Verify todo task at '${index}' with '${name}'
    ${task-field}    Set Variable    xpath:/html/body/div/div/div[3]/ul/li[${index}]
    ${task-field-name}    Set Variable    xpath:/html/body/div/div/div[3]/ul/li[${index}]/label/span[1]
    ${task-name}   Set Variable    xpath:/html/body/div/div/div[3]/ul/li[${index}]/label/span[1]
    ${delete-button}   Set Variable    xpath:/html/body/div/div/div[3]/ul/li[${index}]/button
    ${task-checkbox}   Set Variable    xpath://*[@id="incomplete-tasks"]/li[${index}]/label/span[2]
    ${task-name}    Get text    ${task-field-name}
    Should be equal as strings    ${task-name}    ${task-name}
    element should be visible    ${task-field}
    element should be visible       ${task-field-name}
    element should contain    ${delete-button}    Delete    ignore_case=True
    element should be visible    ${task-checkbox}

Verify completed tasks at '${index}' with '${name}'
    ${completed-task}   Set Variable    xpath://*[@id="completed-tasks"]/li[${index}]
    ${completed-task-name}   Set Variable    xpath:/html/body/div/div/div[4]/ul/li[${index}]/span
    ${completed-task-checked-box}   Set Variable    xpath://*[@id="completed-tasks"]/li[${index}]/span/i
    ${completed-task-delete-button}    Set Variable    xpath:/html/body/div/div/div[4]/ul/li[${index}]/button
    element should be visible    ${completed-task}
    element should be visible    ${completed-task-name}
    ${task-name}    Get text    ${completed-task-name}
    #fail if ${task-name}  not contain  ${name}
    Should contain     ${task-name}    ${name}
    element should be visible    ${completed-task-checked-box}
    element should be visible    ${completed-task-delete-button}
    element should contain    ${completed-task-delete-button}    Delete    ignore_case=True


Create empty completed task
    ${completed-list}     Create list
    Set Test variable    ${completed-list}

Set index to global
    [Arguments]    ${index}
    ${index}=    Convert to string   ${index}
    ${index}=    Evaluate    ${index}
    Set Global Variable    ${index}

Verify common visual exist
    title should be    To-Do List
    element should be visible    ${title-name}
    element should contain    ${add-item-name}    Add Item    ignore_case=True
    element should contain    ${to-do-tasks-name}    To-Do Tasks    ignore_case=True
    element should contain    ${completed-name}    Completed    ignore_case=True

Add item to the list
    [Arguments]    @{items}
    FOR    ${item}    IN    @{items}
        log    ${item}
        Click element    ${add-task-bar}
        Input Text    ${field-add-task}    ${item}
        Click element    ${add-item-button}
    END


click Complete task in todo task on field name
    [Arguments]    ${index}    ${item_list}=${item_list}
    ${len}    Get length    ${item_list}
    ${task-field-name}    Set Variable    xpath://*[@id="incomplete-tasks"]/li[${index}]/label
    Convert to integer    ${index}
    ${index-list}     evaluate    ${index}-1
    ${task}=    Remove From List    ${item_list}    ${index-list}
    Append to List    ${completed-list}    ${task}
    log    ${completed-list}
    Set Test Variable    ${item_list}
    Click element    ${task-field-name}

Delete item from todo task
    [Arguments]    ${index}    ${item_list}
    #reminder index start from 1 2 ... , list index start from 0
    ${delete-button}   Set Variable    xpath:/html/body/div/div/div[3]/ul/li[${index}]/button
    Click element    ${delete-button}
    Convert to integer    ${index}
    ${i_index}    evaluate    ${index}-1
    Remove From List    ${item_list}    ${i_index}
    Set Test Variable    ${item_list}

Delete item from completed task
    [Arguments]    ${index}
    ${completed-task-delete-button}    Set Variable    xpath:/html/body/div/div/div[4]/ul/li[${index}]/button
    Click element    ${completed-task-delete-button}
    ${index-list}     evaluate    ${index}-1
    ${task}=    Remove From List    ${completed-list}    ${index-list}
    log    ${completed-list}


Verify visibilities for fist access
    Verify common visual exist
    element should be visible    ${field-add-task}
    element should be visible    ${add-item-bar}
    element should be visible    ${add-item-button}

Verify visibilities when click on to-do task
    Verify common visual exist
    element should not be visible    ${field-add-task}
    element should not be visible    ${add-item-bar}
    element should not be visible    ${add-item-button}
    element should not be visible    ${tasks-field}
    element should not be visible    ${delete-button}
    element should not be visible    ${task-checkbox}

Verify visibilities when click on to-do task with tasks exist
    [Arguments]     ${item_list}=${item_list}
    Verify common visual exist
    element should not be visible    ${field-add-task}
    element should not be visible    ${add-item-bar}
    element should not be visible    ${add-item-button}
    ${len}=    Get length    ${item_list}
    element should be visible    ${tasks-field}
    FOR    ${i_index}    IN RANGE    ${len}
        ${name}=    Get From List    ${item_list}    ${i_index}
        ${index}=    Set variable     ${i_index+1}
        Verify todo task at '${index}' with '${name}'
    END

Verify visibilities when click on completed
    Verify common visual exist
    element should not be visible    ${field-add-task}
    element should not be visible    ${add-item-bar}
    element should not be visible    ${add-item-button}
    element should not be visible    ${completed-task}


Verify visibilities when click on completed with task exist
    [Arguments]    ${completed-list}=${completed-list}
    Verify common visual exist
    element should not be visible    ${field-add-task}
    element should not be visible    ${add-item-bar}
    element should not be visible    ${add-item-button}
    element should be visible    ${completed-task}
    ${completed-len}    Get length    ${completed-list}
    FOR    ${i_index}    IN RANGE    ${completed-len}
        ${name}=    Get From List    ${completed-list}    ${i_index}
        ${index}=    Set variable     ${i_index+1}
        Verify Completed Tasks At '${index}' With '${name}'

    END


*** Test Cases ***
TC_001
    [Documentation]    Validate when accessing the website (the default)
    Open Website
    Verify visibilities for fist access
    Go to todo tasks
    Verify visibilities when click on to-do task
    Go to completed task
    Verify visibilities when click on completed


TC_002
    [Documentation]    Be able to add item successfully and the item is shown on todo-tasks sequencially
    @{item_list}    Create list    Do home work    Do house work     Dodo
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}


TC_003
    [Documentation]    Be able to delete item(s) successfully from todo tasks
    @{item_list}    Create list    Test 1     Do house work     Dodo    Test 2
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    #${item_list}     Set Test Variable    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    #delete task number 1 which is Test 1
    Delete Item From Todo Task    1      ${item_list}
    log    ${item_list}
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Delete Item From Todo Task    3      ${item_list}
    log    ${item_list}
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}

TC_004
    [Documentation]    Be able to complete the task(s) successfully from todo tasks
    @{item_list}    Create list    Do home work     Do house work     Dodo    Test
    create empty completed task
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Click complete task in todo task on field name    1    ${item_list}
    Click complete task in todo task on field name    1    ${item_list}
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Go To Completed Task
    Verify Visibilities When Click On Completed With Task Exist

TC_005
    [Documentation]    Be able to delete completed task(s) successfully
    @{item_list}    Create list    Do home work     Do house work     Dodo    Test 2
    Create empty completed task
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Click complete task in todo task on field name    1    ${item_list}
    Click complete task in todo task on field name    1    ${item_list}
    Click complete task in todo task on field name    1    ${item_list}
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    log     ${completed-list}
    go to completed task
    Delete Item From Completed Task    3
    Verify Visibilities When Click On Completed With Task Exist
    Delete Item From Completed Task    1
    Verify Visibilities When Click On Completed With Task Exist


TC_006
    [Documentation]    todo tasks and completed tasks is not disappear after swiched tab
    @{item_list}    Create list    Do home work     Do house work     Dodo    Test 2
    ...    sleep at 11.00 PM   buy a horse    take some nap    go market at 12.00
    Create empty completed task
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    click complete task in todo task on field name    5    ${item_list}
    Go To Completed Task
    Verify Visibilities When Click On Completed With Task Exist
    Go To Todo Tasks
    click complete task in todo task on field name    1
    Verify Visibilities When Click On To-do Task With Tasks Exist   ${item_list}
    go to add item
    Verify visibilities for fist access
    go to todo tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist   ${item_list}
    go to completed task
    Verify Visibilities When Click On Completed With Task Exist

TC_007
    [Documentation]    Simply add an long task
    @{item_list}    Create list    go market at 12.00 then go shopping at dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd store
    Create empty completed task
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}

TC_008
    [Documentation]    Simply reload page and all tasks are not disaapear
    @{item_list}    Create list      Do home work     Do house work     Dodo    Test 2
    ...    sleep at 11.00 PM   buy a horse    take some nap    go market at 12.00
    Create empty completed task
    Open Website
    Verify visibilities for fist access
    Add item to the list    @{item_list}
    Go To Todo Tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Click Complete Task In Todo Task On Field Name  4    ${item_list}
    Click Complete Task In Todo Task On Field Name  5    ${item_list}
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Reload page
    Verify visibilities for fist access
    go to todo tasks
    Verify Visibilities When Click On To-do Task With Tasks Exist    ${item_list}
    Reload page
    Verify visibilities for fist access
    Go To Completed Task
    Verify Visibilities When Click On Completed With Task Exist
