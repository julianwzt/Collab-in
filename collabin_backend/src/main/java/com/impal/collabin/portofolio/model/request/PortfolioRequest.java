package com.impal.collabin.portofolio.model.request;

import lombok.Data;

@Data
public class PortfolioRequest {
    private Integer portfolioId;
    private String title;
    private String description;
    private String fileUrl;
    private String image;

}