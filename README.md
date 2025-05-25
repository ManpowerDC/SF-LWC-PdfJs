# SF-LWC-PdfJs 📄

![GitHub Releases](https://img.shields.io/github/release/ManpowerDC/SF-LWC-PdfJs.svg) [![Download Releases](https://img.shields.io/badge/Download%20Releases-blue.svg)](https://github.com/ManpowerDC/SF-LWC-PdfJs/releases)

Welcome to the **SF-LWC-PdfJs** repository! This project demonstrates how to integrate the Pdf.js library into a Salesforce Lightning Web Component (LWC). By leveraging Pdf.js, you can render PDF documents seamlessly within your Salesforce applications.

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Components](#components)
6. [License](#license)
7. [Contributing](#contributing)
8. [Support](#support)

## Introduction

The SF-LWC-PdfJs project serves as a bridge between Salesforce's powerful Lightning Web Components and the robust Pdf.js library. Pdf.js allows you to display PDF files directly in your web applications, enhancing user experience by providing quick access to documents without leaving the platform.

## Features

- **Easy Integration**: Quickly add PDF viewing capabilities to your LWC.
- **Responsive Design**: The PDF viewer adjusts to different screen sizes.
- **Fast Rendering**: Utilize Pdf.js for efficient rendering of PDF files.
- **User-Friendly Interface**: Navigate through documents with ease.

## Installation

To get started with the SF-LWC-PdfJs, you need to download the latest release from our [Releases page](https://github.com/ManpowerDC/SF-LWC-PdfJs/releases). Follow these steps:

1. Visit the [Releases page](https://github.com/ManpowerDC/SF-LWC-PdfJs/releases).
2. Download the latest release package.
3. Extract the files to your local environment.
4. Deploy the components to your Salesforce org.

## Usage

Once you have installed the components, you can use them in your Salesforce application. Here’s a quick guide on how to implement the PDF viewer in your LWC.

### Step 1: Import the Pdf.js Library

Ensure that you include the Pdf.js library in your component. You can do this by adding the library files to your static resources in Salesforce.

### Step 2: Create the PDF Viewer Component

Create a new LWC component, for example, `pdfViewer`. Inside the component, you will set up the HTML and JavaScript to handle the PDF rendering.

#### HTML File (pdfViewer.html)

```html
<template>
    <div class="pdf-viewer">
        <canvas id="pdf-canvas"></canvas>
    </div>
</template>
```

#### JavaScript File (pdfViewer.js)

```javascript
import { LightningElement, api } from 'lwc';

export default class PdfViewer extends LightningElement {
    @api pdfUrl;

    renderedCallback() {
        this.loadPdf();
    }

    loadPdf() {
        const pdfjsLib = window['pdfjs-dist/build/pdf'];
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'path/to/pdf.worker.js';

        pdfjsLib.getDocument(this.pdfUrl).promise.then(pdf => {
            pdf.getPage(1).then(page => {
                const scale = 1.5;
                const viewport = page.getViewport({ scale: scale });
                const canvas = this.template.querySelector('#pdf-canvas');
                const context = canvas.getContext('2d');
                canvas.height = viewport.height;
                canvas.width = viewport.width;

                const renderContext = {
                    canvasContext: context,
                    viewport: viewport
                };
                page.render(renderContext);
            });
        });
    }
}
```

### Step 3: Use the Component in Your Application

You can now use the `pdfViewer` component in any of your Lightning pages. Pass the PDF URL as a property to the component.

```html
<template>
    <c-pdf-viewer pdf-url="https://example.com/path/to/your.pdf"></c-pdf-viewer>
</template>
```

## Components

This repository includes the following key components:

- **PdfViewer**: The main component that handles PDF rendering.
- **Pdf.js Library**: The external library used for rendering PDFs.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

We welcome contributions to the SF-LWC-PdfJs project! If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeature`).
6. Open a pull request.

## Support

If you encounter any issues or have questions, please check the "Releases" section for updates or create an issue in the repository. We are here to help!

---

Feel free to explore the repository, experiment with the code, and enhance your Salesforce applications with PDF viewing capabilities! For more details, visit the [Releases page](https://github.com/ManpowerDC/SF-LWC-PdfJs/releases).