package com.impal.collabin.search.service;

import com.impal.collabin.search.model.response.SearchResponse;

public interface SearchService {

    SearchResponse globalSearch(
            String authorizationHeader,
            String query
    );
}