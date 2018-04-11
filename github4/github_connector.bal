//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import ballerina/http;

documentation {GitHub client connector
    F{{accessToken}} - Access token for GitHub API
    F{{githubGraphQlClient}} - Http client for GitHub GraphQL API
    F{{githubRestClient}} - Http client for GitHub REST API
}
public type GitHubConnector object{
    public {
        string accessToken;
        http:Client githubGraphQlClient = new;
        http:Client githubRestClient = new;
    }

    documentation { Creates a new issue in a repository.
        P{{repository}} - Repository object
        P{{issue}} - Issue object
        R{{}} - Created issue object
        R{{}} - Connector error
    }
    public function createIssue (Repository repository, Issue issue)
                    returns Issue|GitConnectorError;

    documentation { Get the next page of the card list
        P{{cardList}} - Card list object
        R{{}} - Card list object of next page
        R{{}} - Connector error
    }
    public function getCardListNextPage (CardList cardList)
                    returns CardList|GitConnectorError;

    documentation { Get the next page of column list
        P{{columnList}} - Column list object
        R{{}} - Column list object of next page
        R{{}} - Connector error
    }
    public function getColumnListNextPage (ColumnList columnList)
                    returns ColumnList|GitConnectorError;

    documentation { Get a list of issues of a repository
        P{{repository}} - Repository object
        P{{state}} - State of the issue (GIT_STATE_OPEN, GIT_STATE_CLOSED, GIT_STATE_ALL)
        P{{recordCount}} - Specify number of records in the list
        R{{}} - Issue list object
        R{{}} - Connector error
    }
    public function getIssueList (Repository repository, string state, int recordCount)
                    returns IssueList|GitConnectorError;

    documentation { Get the next page of the issue list
        P{{issueList}} - Issue list object
        R{{}} - Issue list object of next page
        R{{}} - Connector error
    }
    public function getIssueListNextPage (IssueList issueList)
                    returns IssueList|GitConnectorError;

    documentation { Get an organization
        P{{name}} - Name of the organization
        R{{}} - Organization object
        R{{}} - Connector error
    }
    public function getOrganization (string name)
                    returns Organization|GitConnectorError;

    documentation { Get a single project of an organization
        P{{organization}} - Organization object
        P{{projectNumber}} - The number of the project
        R{{}} - Project object
        R{{}} - Connector error
    }
    public function getOrganizationProject (Organization organization, int projectNumber)
                    returns Project|GitConnectorError;

    documentation { Get all projects of an organization
        P{{organization}} - Organization object
        P{{state}} - State of the project (GIT_STATE_OPEN, GIT_STATE_CLOSED, GIT_STATE_ALL)
        P{{recordCount}} - Specify number of records in the list
        R{{}} - Project list object
        R{{}} - Connector error
    }
    public function getOrganizationProjectList (Organization organization, string state, int recordCount)
                    returns ProjectList|GitConnectorError;

    documentation { Get a list of repositories of an organization
        P{{organization}} - Organization object
        P{{recordCount}} - Specify number of records in the list
        R{{}} - Repository list object
        R{{}} - Connector error
    }
    public function getOrganizationRepositoryList (Organization organization, int recordCount)
                    returns RepositoryList|GitConnectorError;

    documentation { Get all columns of a project board
        P{{project}} - Project object
        P{{recordCount}} - Specify number of records in the list
        R{{}} - Column list object
        R{{}} - Connector error
    }
    public function getProjectColumnList (Project project, int recordCount)
                    returns ColumnList|GitConnectorError;
    documentation { Gets the next page of a project list
        P{{projectList}} - Project list object
        R{{}} - Project list object of next page
        R{{}} - Connector error
    }
    public function getProjectListNextPage (ProjectList projectList)
                    returns ProjectList|GitConnectorError;

    documentation { Get all pull requests of a repository
        P{{repository}} - Repository object
        P{{state}} - State of the pull request (GIT_STATE_OPEN, GIT_STATE_CLOSED, GIT_STATE_MERGED, GIT_STATE_ALL)
        P{{recordCount}} - Specify number of records in the list
        R{{}} - Pull request list object
        R{{}} - Connector error
    }
    public function getPullRequestList (Repository repository, string state, int recordCount)
                    returns PullRequestList|GitConnectorError;

    documentation { Get the next page of the pull request list
        P{{pullRequestList}} - Pull request list object
        R{{}} - Pull request list object of next page
        R{{}} - Connector error
    }
    public function getPullRequestListNextPage (PullRequestList pullRequestList)
                    returns PullRequestList|GitConnectorError;

    documentation { Get a repository of an owner
        P{{name}} - Name of the repository and its owner Format: ("owner/repository")
        R{{}} - Repository object
        R{{}} - Connector error
    }
    public function getRepository (string name)
                    returns Repository|GitConnectorError;

    documentation { Get the next page of a repository list
        P{{repositoryList}} - Repository list object
        R{{}} - Repository list object of next page
        R{{}} - Connector error
    }
    public function getRepositoryListNextPage (RepositoryList repositoryList)
                    returns RepositoryList|GitConnectorError;

    documentation { Get a single project of a repository
        P{{repository}} - Repository object
        P{{projectNumber}} - Project identification number
        R{{}} - Project object
        R{{}} - Connector error
    }
    public function getRepositoryProject (Repository repository, int projectNumber)
                    returns Project|GitConnectorError;

    documentation { Get all projects of a repository
        P{{repository}} - Repository object
        P{{state}} - State of the project (GIT_STATE_OPEN, GIT_STATE_CLOSED, GIT_STATE_ALL)
        P{{recordCount}} - Specify number of records in the list
        R{{}} - Project list object
        R{{}} - Connector error
    }
    public function getRepositoryProjectList (Repository repository, string state, int recordCount)
                    returns ProjectList|GitConnectorError;
};


public function GitHubConnector::createIssue (Repository repository, Issue issue) returns Issue|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubRestClient;

    GitConnectorError connectorError = {};

    if (repository.name == "" || issue.title == "") {
        connectorError = {message:["Repository and issue should be specified."]};
        return connectorError;
    }

    json[] labelList;
    foreach i, label in issue.labels.getAllLabels() {
        labelList[i] = label.name;
    }

    json[] assigneeList;
    foreach i, assignee in issue.assignees.getAllAssignees() {
        assigneeList[i] = assignee.login;
    }

    json issueJsonPayload = {"title":issue.title, "body":issue.bodyText, "labels":labelList, "assignees":assigneeList};

    http:Request request = new;
    constructRequest(request, issueJsonPayload, self.accessToken);

    string repositoryName = repository.name;
    string repositoryOwner = repository.owner.login;
    string endpointResource = "/repos"+ GIT_PATH_SEPARATOR + repositoryOwner + GIT_PATH_SEPARATOR + repositoryName
                                                                                    + GIT_PATH_SEPARATOR + "issues";
    // Make an HTTP POST request
    var response = gitHubEndpoint -> post(endpointResource, request);

    match response {
        http:Response httpResponse => {
            json jsonPayload = httpResponse.getJsonPayload() but { http:PayloadError => null };

            if (jsonPayload != null) {
                var issueObject = jsonToIssue(jsonPayload);
                return issueObject;
            } else {
                connectorError = {message:["Error in creating issue"]};
                return connectorError;
            }
        }

        http:HttpConnectorError httpError => {
            connectorError = {message:[httpError.message], statusCode:httpError.statusCode};
            return connectorError;
        }
    }
}

public function GitHubConnector::getCardListNextPage (CardList cardList) returns CardList|GitConnectorError {

    if (cardList.hasNextPage()) {
        var cardListColumnId = cardList.columnId;
        var convertedQuery = stringToJson(cardList.cardListQuery);
        match convertedQuery {
            json jsonQuery => {
                jsonQuery.variables.endCursorCards = cardList.pageInfo.endCursor;

                if (cardList.listOwner.equalsIgnoreCase(GIT_ORGANIZATION)) {
                    jsonQuery["query"] = GET_ORGANIZATION_PROJECT_CARDS_NEXT_PAGE;
                    ColumnList|GitConnectorError columnList = getProjectColumns(GIT_ORGANIZATION,
                        jsonQuery.toString() ?: "", self.accessToken, self.githubGraphQlClient);
                    match columnList {
                        ColumnList colList => {
                            foreach column in colList.getAllColumns() {
                                if (column.id == cardListColumnId) {
                                    return column.getCardList();
                                }
                            }
                        }

                        GitConnectorError gitConError => {
                            return gitConError;
                        }
                    }

                } else if (cardList.listOwner.equalsIgnoreCase(GIT_REPOSITORY)) {
                    jsonQuery["query"] = GET_REPOSITORY_PROJECT_CARDS_NEXT_PAGE;
                    ColumnList|GitConnectorError columnList = getProjectColumns(GIT_REPOSITORY,
                        jsonQuery.toString() ?: "", self.accessToken, self.githubGraphQlClient);
                    match columnList {
                        ColumnList colList => {
                            foreach column in colList.getAllColumns() {
                                if (column.id == cardListColumnId) {
                                    return column.getCardList();
                                }
                            }
                        }

                        GitConnectorError gitConError => {
                            return gitConError;
                        }
                    }
                }
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

    }
    GitConnectorError connectorError = {message:["Card list has no next page"]};

    return connectorError;
}

public function GitHubConnector::getColumnListNextPage (ColumnList columnList) returns ColumnList|GitConnectorError {

    if (columnList.hasNextPage()) {
        var convertedQuery = stringToJson(columnList.columnListQuery);
        match convertedQuery {
            json jsonQuery => {
                jsonQuery.variables.endCursorColumns = columnList.pageInfo.endCursor;
                if (columnList.listOwner.equalsIgnoreCase(GIT_ORGANIZATION)) {
                    jsonQuery["query"] = GET_ORGANIZATION_PROJECT_COLUMNS_NEXT_PAGE;

                    return getProjectColumns(GIT_ORGANIZATION, jsonQuery.toString() ?: "",
                        self.accessToken, self.githubGraphQlClient);
                } else if (columnList.listOwner.equalsIgnoreCase(GIT_REPOSITORY)) {
                    jsonQuery["query"] = GET_REPOSITORY_PROJECT_COLUMNS_NEXT_PAGE;

                    return getProjectColumns(GIT_REPOSITORY, jsonQuery.toString() ?: "",
                        self.accessToken, self.githubGraphQlClient);
                }
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

    }
    GitConnectorError connectorError = {message:["Column list has no next page"]};

    return connectorError;
}

public function GitHubConnector::getIssueList (Repository repository, string state, int recordCount)
                                                                                returns IssueList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (repository == null) {
        connectorError = {message:["Repository cannot be null"]};
        return connectorError;
    }

    if (recordCount > GIT_MAX_RECORD_COUNT) {
        connectorError = {message:["Maximum record count limited to " + GIT_MAX_RECORD_COUNT]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_REPOSITORY_ISSUES,
        [repository.owner.login, repository.name, state, recordCount]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    //Check for empty payloads and errors
    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_ISSUES);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubIssuesJson = jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY][GIT_ISSUES];
            var issueList = jsonToIssueList(githubIssuesJson, stringQuery);

            return issueList;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}

public function GitHubConnector::getIssueListNextPage (IssueList issueList) returns IssueList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    if (issueList.hasNextPage()) {
        http:Request request = new;
        var convertedQuery = stringToJson(issueList.issueListQuery);
        match convertedQuery {
            json jsonQuery => {
                jsonQuery.variables.endCursorIssues = issueList.pageInfo.endCursor;
                jsonQuery["query"] = GET_REPOSITORY_ISSUES_NEXT_PAGE;
                //Set headers and payload to the request
                constructRequest(request, jsonQuery, self.accessToken);
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

        // Make an HTTP POST request
        var response = gitHubEndpoint -> post("", request);

        //Check for empty payloads and errors
        json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_ISSUES);
        match validatedResponse {
            json jsonValidatedResponse => {
                var repositoryIssuesJson = jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY][GIT_ISSUES];
                var issuesList = jsonToIssueList(repositoryIssuesJson, issueList.issueListQuery);

                return issuesList;
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

    }
    GitConnectorError connectorError = {message:["Issue list has no next page"]};

    return connectorError;

}

public function GitHubConnector::getOrganization (string name) returns Organization|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (null == name || "" == name) {
        connectorError = {message:["Organization name should be specified."]};
        return connectorError;
    }
    Organization singleOrganization = {};

    string stringQuery = io:sprintf(TEMPLATE_GET_ORGANIZATION, [name]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            // Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_NAME);

    match validatedResponse {
        json jsonValidatedResponse => {
            try {
                var githubRepositoryJson = <json>jsonValidatedResponse[GIT_DATA][GIT_ORGANIZATION];
                singleOrganization = check <Organization>githubRepositoryJson;
            } catch (error e) {
                connectorError = {message:[e.message]};
                return connectorError;
            }
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    return singleOrganization;
}

public function GitHubConnector::getOrganizationProject (Organization organization, int projectNumber)
                                                                                returns Project|GitConnectorError {
    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (organization == null || projectNumber <= 0) {
        connectorError = {message:["Organization cannot be null and project number should be positive integer."]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_ORGANIZATION_PROJECT, [organization.login, projectNumber]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PROJECT);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubProjectJson = jsonValidatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_PROJECT];
            var singleProject = check <Project>githubProjectJson;

            return singleProject;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}

public function GitHubConnector::getOrganizationProjectList (Organization organization, string state, int recordCount)
                                                                            returns ProjectList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (organization == null || state == null) {
        connectorError = {message:["Organization and state cannot be null."]};
        return connectorError;
    }

    if (recordCount > GIT_MAX_RECORD_COUNT) {
        connectorError = {message:["Maximum record count limited to " + GIT_MAX_RECORD_COUNT]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_ORGANIZATION_PROJECTS, [organization.login, state, recordCount]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    //Check for empty payloads and errors
    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PROJECTS);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubProjectsJson = jsonValidatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_PROJECTS];
            var projectList = jsonToProjectList(githubProjectsJson, GIT_ORGANIZATION, stringQuery);

            return projectList;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}

public function GitHubConnector::getOrganizationRepositoryList (Organization organization, int recordCount)
                                                                        returns RepositoryList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (organization == null) {
        connectorError = {message:["Organization cannot be null."]};
        return connectorError;
    }

    if (recordCount > GIT_MAX_RECORD_COUNT) {
        connectorError = {message:["Maximum record count limited to " + GIT_MAX_RECORD_COUNT]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_ORGANIZATION_REPOSITORIES, [organization.login, recordCount]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    //Check for empty payloads and errors
    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_REPOSITORIES);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubRepositoriesJson = jsonValidatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORIES];
            var repositoryList = jsonToRepositoryList(githubRepositoriesJson, stringQuery);

            return repositoryList;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}

public function GitHubConnector::getProjectColumnList (Project project, int recordCount)
                                                                            returns ColumnList|GitConnectorError {

    GitConnectorError connectorError = {};

    if (project == null) {
        connectorError = {message:["Project cannot be null"]};
        return connectorError;
    }

    if (recordCount > GIT_MAX_RECORD_COUNT) {
        connectorError = {message:["Maximum record count limited to " + GIT_MAX_RECORD_COUNT]};
        return connectorError;
    }
    string projectOwnerType = project.owner.getOwnerType();
    if (projectOwnerType.equalsIgnoreCase(GIT_ORGANIZATION) && project.resourcePath != null) {
        string organization = project.resourcePath.split(GIT_PATH_SEPARATOR)[GIT_INDEX_TWO];
        string stringQuery = io:sprintf(TEMPLATE_GET_ORGANIZATION_PROJECT_COLUMNS,
            [organization, project.number, recordCount]);

        return getProjectColumns(GIT_ORGANIZATION, stringQuery, self.accessToken, self.githubGraphQlClient);

    } else if (projectOwnerType.equalsIgnoreCase(GIT_REPOSITORY) && project.resourcePath != null) {
        string ownerName = project.resourcePath.split(GIT_PATH_SEPARATOR)[GIT_INDEX_ONE];
        string repositoryName = project.resourcePath.split(GIT_PATH_SEPARATOR)[GIT_INDEX_TWO];
        string stringQuery = io:sprintf(TEMPLATE_GET_REPOSITORY_PROJECT_COLUMNS,
            [ownerName, repositoryName, project.number, recordCount]);

        return getProjectColumns(GIT_REPOSITORY, stringQuery, self.accessToken, self.githubGraphQlClient);
    }
    connectorError.message = ["No records found"];
    return connectorError;
}

public function GitHubConnector::getProjectListNextPage (ProjectList projectList)
                                                                            returns ProjectList|GitConnectorError {
    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    if (projectList.hasNextPage()) {

        http:Request request = new;
        json dataQuery;
        var convertedQuery = stringToJson(projectList.projectListQuery);
        match convertedQuery {
            json jsonQuery => {
                jsonQuery.variables.endCursorProjects = projectList.pageInfo.endCursor;
                if (projectList.listOwner.equalsIgnoreCase(GIT_ORGANIZATION)) {
                    jsonQuery["query"] = GET_ORGANIZATION_PROJECTS_NEXT_PAGE;
                } else if (projectList.listOwner.equalsIgnoreCase(GIT_REPOSITORY)) {
                    jsonQuery["query"] = GET_REPOSITORY_PROJECTS_NEXT_PAGE;
                }
                dataQuery = jsonQuery;
                //Set headers and payload to the request
                constructRequest(request, jsonQuery, self.accessToken);
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

        // Make an HTTP POST request
        var response = gitHubEndpoint -> post("", request);

        //Check for empty payloads and errors
        json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PROJECTS);

        match validatedResponse {
            json jsonValidatedResponse => {
                var projectsJson = jsonValidatedResponse[GIT_DATA][projectList.listOwner][GIT_PROJECTS];
                var projList =  jsonToProjectList(projectsJson, projectList.listOwner, dataQuery.toString() ?: "");

                return projList;
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }
    }

    GitConnectorError connectorError = {message:["Project list has no next page"]};

    return connectorError;
}

public function GitHubConnector::getPullRequestList (Repository repository, string state, int recordCount)
                                                                        returns PullRequestList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (repository == null || state == "" || state == null) {
        connectorError = {message:["Repository and state cannot be null."]};
        return connectorError;
    }

    if (recordCount > GIT_MAX_RECORD_COUNT) {
        connectorError = {message:["Maximum record count limited to " + GIT_MAX_RECORD_COUNT]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_PULL_REQUESTS,
        [repository.owner.login, repository.name, state, recordCount]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    //Check for empty payloads and errors
    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PULL_REQUESTS);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubPullRequestsJson = jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY][GIT_PULL_REQUESTS];
            var pullRequestList = jsonToPullRequestList(githubPullRequestsJson, stringQuery);

            return pullRequestList;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}

public function GitHubConnector::getPullRequestListNextPage (PullRequestList pullRequestList)
                                                                        returns PullRequestList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    if (pullRequestList.hasNextPage()) {

        http:Request request = new;
        var convertedQuery = stringToJson(pullRequestList.pullRequestListQuery);
        match convertedQuery {
            json jsonQuery => {
                jsonQuery.variables.endCursorPullRequests = pullRequestList.pageInfo.endCursor;
                jsonQuery["query"] = GET_PULL_REQUESTS_NEXT_PAGE;
                //Set headers and payload to the request
                constructRequest(request, jsonQuery, self.accessToken);
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

        // Make an HTTP POST request
        var response = gitHubEndpoint -> post("", request);

        //Check for empty payloads and errors
        json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PULL_REQUESTS);

        match validatedResponse {
            json jsonValidatedResponse => {
                var projectColumnsJson = jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY][GIT_PULL_REQUESTS];
                var prList = jsonToPullRequestList(projectColumnsJson, pullRequestList.pullRequestListQuery);

                return prList;
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

    }
    GitConnectorError connectorError = {message:["Pull request list has no next page"]};

    return connectorError;
}

public function GitHubConnector::getRepository (string name) returns Repository|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (name == null || name == "") {
        connectorError = {message:["Repository owner and name should be specified."]};
        return connectorError;
    }
    string[] repoIdentifier = name.split(GIT_PATH_SEPARATOR);
    string repoOwner = repoIdentifier[GIT_INDEX_ZERO];
    string repoName = repoIdentifier[GIT_INDEX_ONE];
    Repository singleRepository = {};

    string stringQuery = io:sprintf(TEMPLATE_GET_REPOSITORY, [repoOwner, repoName]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            // Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request 
    var response = gitHubEndpoint -> post("", request);

    json|GitConnectorError validatedResponse  = getValidatedResponse(response, GIT_NAME);
    
    match validatedResponse {
        json jsonValidatedResponse => {
            try {
                var githubRepositoryJson = <json>jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY];
                singleRepository = jsonToRepository(githubRepositoryJson);
            } catch (error e) {
                connectorError = {message:[e.message]};
                return connectorError;
            }
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
    
    return singleRepository;
}

public function GitHubConnector::getRepositoryListNextPage (RepositoryList repositoryList)
                                                                            returns RepositoryList|GitConnectorError {
    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    if (repositoryList.hasNextPage()) {

        http:Request request = new;
        var convertedQuery = stringToJson(repositoryList.repositoryListQuery);
        match convertedQuery {
            json jsonQuery => {
                jsonQuery.variables.endCursorRepos = repositoryList.pageInfo.endCursor;
                jsonQuery["query"] = GET_ORGANIZATION_REPOSITORIES_NEXT_PAGE;
                //Set headers and payload to the request
                constructRequest(request, jsonQuery, self.accessToken);
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }

        // Make an HTTP POST request
        var response = gitHubEndpoint -> post("", request);

        //Check for empty payloads and errors
        json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_REPOSITORIES);

        match validatedResponse {
            json jsonValidatedResponse => {
                var repositoriesJson = jsonValidatedResponse[GIT_DATA][GIT_ORGANIZATION][GIT_REPOSITORIES];
                var repoList =  jsonToRepositoryList(repositoriesJson, repositoryList.repositoryListQuery);

                return repoList;
            }

            GitConnectorError gitConError => {
                return gitConError;
            }
        }
    }
    GitConnectorError connectorError = {message:["Repository list has no next page"]};

    return connectorError;
}

public function GitHubConnector::getRepositoryProject (Repository repository, int projectNumber)
                                                                                returns Project|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (repository == null || projectNumber <= 0) {
        connectorError = {message:["Repository cannot be null and project number should be positive integer."]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_REPOSITORY_PROJECT,
        [repository.owner.login, repository.name, projectNumber]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
            //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    //Check for empty payloads and errors
    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PROJECT);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubProjectJson = jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY][GIT_PROJECT];
            var singleProject = check <Project>githubProjectJson;

            return singleProject;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}

public function GitHubConnector::getRepositoryProjectList
                        (Repository repository, string state, int recordCount) returns ProjectList|GitConnectorError {

    endpoint http:Client gitHubEndpoint = self.githubGraphQlClient;

    GitConnectorError connectorError = {};

    if (repository == null || state == null) {
        connectorError = {message:["Repository and state cannot be null"]};
        return connectorError;
    }

    if (recordCount > GIT_MAX_RECORD_COUNT) {
        connectorError = {message:["Maximum record count limited to " + GIT_MAX_RECORD_COUNT]};
        return connectorError;
    }

    string stringQuery = io:sprintf(TEMPLATE_GET_REPOSITORY_PROJECTS,
                                    [repository.owner.login, repository.name, state, recordCount]);

    http:Request request = new;
    var convertedQuery = stringToJson(stringQuery);
    match convertedQuery {
        json jsonQuery => {
        //Set headers and payload to the request
            constructRequest(request, jsonQuery, self.accessToken);
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }

    // Make an HTTP POST request
    var response = gitHubEndpoint -> post("", request);

    //Check for empty payloads and errors
    json|GitConnectorError validatedResponse = getValidatedResponse(response, GIT_PROJECTS);

    match validatedResponse {
        json jsonValidatedResponse => {
            var githubProjectsJson = jsonValidatedResponse[GIT_DATA][GIT_REPOSITORY][GIT_PROJECTS];
            var projectList = jsonToProjectList(githubProjectsJson, GIT_REPOSITORY, stringQuery);

            return projectList;
        }

        GitConnectorError gitConError => {
            return gitConError;
        }
    }
}