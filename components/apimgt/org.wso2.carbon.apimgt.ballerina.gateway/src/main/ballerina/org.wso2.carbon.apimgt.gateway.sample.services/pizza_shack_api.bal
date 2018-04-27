// Copyright (c)  WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/http;
import org.wso2.carbon.apimgt.gateway.listeners as listeners;

listeners:AuthProvider basicAuthProvider = {id: "oauth2", scheme:"oauth2", authProvider:"config"};
endpoint listeners:APIGatewayListener listener {
    //port:9091
    //authProviders:[basicAuthProvider]
};

endpoint http:Client pizzaShackEP {
    url: "https://localhost:9443/am/sample/pizzashack/v1/api/"
};

@http:ServiceConfig {
    basePath:"/pizzashack/1.0.0",
    authConfig:{
        authProviders:["oauth2"],
        authentication:{enabled:true},
        scopes:["default"]
    }

}
service<http:Service> pizzashack bind listener {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/menu",
        authConfig:{
            authProviders:["oauth2"],
            authentication:{enabled:true},
            scopes:["default"]
        }
    }
    getMenu (endpoint conn, http:Request req) {
        var result = pizzaShackEP -> get("/menu", request = req);
        match result {
            http:Response clientResponse => {
                _ = conn -> respond(clientResponse);
            }
            any|() => {}
        }
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"/order",
        authConfig:{
            authProviders:["oauth2"],
            authentication:{enabled:true},
            scopes:["default"]
        }
    }
    addOrder (endpoint conn, http:Request req) {
        var result = pizzaShackEP -> post("/order", request = req);
        match result {
            http:Response clientResponse => {
                _ = conn -> respond(clientResponse);
            }
            any|() => {}
        }
    }
}