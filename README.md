# datadog-lab

> My personal datadog lab. 

This project guides you through setting up observability using **Datadog** for middleware, applications, and Kubernetes infrastructure — including metrics, logs, traces, alerts, and dashboards.

---

## 📋 Requirements

Before you start, make sure you have:

- A **Datadog trial account** (trial lasts 15 days);
- A machine or desktop for installing the Datadog Agent;
- Access to **3 machines or nodes** (can be physical, virtual, or containerized) for a local Kubernetes cluster;

---

## 🖥️ Host Setup

1. **Install Datadog Agent** on your desktop or any machine.
2. Configure the Datadog Agent to collect:
   - APM (Application Performance Monitoring)
   - Logs
   - Metrics
3. Install and configure **Apache HTTP Server** and **RabbitMQ**.
4. Integrate Apache and RabbitMQ with Datadog.
5. Present the standard Datadog dashboards for these middlewares.

---

## ☸️ Kubernetes Setup

1. Build a **local Kubernetes cluster** with 3 nodes using Kind. [Optional]
2. Integrate this Kubernetes cluster with your Datadog account, enabling the Datadog Cluster Agent.
3. Deploy the following applications (Java, .NET, Python) from the directory `apm`:
```apm
├── dotnet
├── java
└── python
```
4. Instrument these applications to collect and correlate metrics, logs and traces.

---

## 🚨 Alerts Setup

1. Create a monitor that triggers an alert when a **pod exceeds 75% memory usage**.
   - Notification via **email**.
2. Create a monitor that triggers an alert when a **pod enters CrashLoopBackOff state**.
   - Notification via **email**.

---

## 📊 Dashboards

Create a Datadog dashboard to quickly identify application errors by combining:

- Logs
- Metrics
- Traces

Include:

- Error rate visualization;
- Currently errors with greater occurence;

---

## 🎯 Goal

Enable full observability and monitoring for middleware and Kubernetes applications, improving detection and response to operational issues using Datadog.
