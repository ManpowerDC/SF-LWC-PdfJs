import { LightningElement, api, track } from 'lwc';
import pdfjsWeb from '@salesforce/resourceUrl/pdfjs';
import getPdfContent from '@salesforce/apex/PdfViewerController.getPdfContent';

export default class Pdfjsviewer extends LightningElement {
    @api recordId;
    @track loading = true;
    @track errorMessage = '';

    renderedCallback() {
        if (this._initialized) return;
        this._initialized = true;
        this.loadPdf();
    }

    loadPdf() {
        // Pass the record ID to Apex
        getPdfContent({ recordId: this.recordId })
            .then(base64Data => {
                // Convert base64 to Blob URL
                const binaryString = window.atob(base64Data);
                const bytes = new Uint8Array(binaryString.length);
                for (let i = 0; i < binaryString.length; i++) {
                    bytes[i] = binaryString.charCodeAt(i);
                }
                const blob = new Blob([bytes], { type: 'application/pdf' });
                const blobUrl = URL.createObjectURL(blob);
                this.renderViewer(blobUrl);
            })
            .catch(error => {
                this.errorMessage = 'Error loading PDF: ' + (error.body?.message || error.message);
                this.loading = false;
            });
    }

    renderViewer(blobUrl) {
        const iframe = this.template.querySelector('.pdfjs-iframe');
        if (!iframe) {
            this.errorMessage = 'Viewer iframe not found';
            this.loading = false;
            return;
        }
        // Compose the viewer.html URL with the Blob URL as the file param
        const viewerUrl = `${pdfjsWeb}/web/viewer.html?file=${encodeURIComponent(blobUrl)}`;
        iframe.src = viewerUrl;
        this.loading = false;
    }
}