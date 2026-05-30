// dotenv not needed on Vercel — env vars are injected natively
// Only load locally via process.env fallback
import express from "express";
import cors from "cors";
import { registerRoutes } from "./routes";
import { createServer } from "http";

const app = express();

app.use(
    cors({
        origin: true,
        credentials: true,
    })
);

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

const httpServer = createServer(app);

// Store the initialization promise so it only runs once per cold start
const initPromise = registerRoutes(httpServer, app).catch((err) => {
    console.error("Route initialization failed:", err);
});

// Vercel calls this default export as the serverless handler
export default async function handler(req: any, res: any) {
    try {
        await initPromise;
    } catch (err) {
        console.error("Init error:", err);
    }
    return app(req, res);
}
