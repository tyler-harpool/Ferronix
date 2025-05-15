use anyhow::Result;
use clap::Parser;
use std::path::PathBuf;
use tracing::{info, Level};
use tracing_subscriber::FmtSubscriber;

/// A simple Rust application with Nix integration
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Optional name to greet
    #[arg(short, long)]
    name: Option<String>,

    /// Optional file to read
    #[arg(short, long)]
    file: Option<PathBuf>,

    /// Set the verbosity level
    #[arg(short, long, default_value_t = false)]
    verbose: bool,
}

fn setup_logging(verbose: bool) {
    let level = if verbose { Level::DEBUG } else { Level::INFO };
    
    let subscriber = FmtSubscriber::builder()
        .with_max_level(level)
        .finish();
    
    tracing::subscriber::set_global_default(subscriber)
        .expect("Failed to set tracing subscriber");
}

#[tokio::main]
async fn main() -> Result<()> {
    let args = Args::parse();
    setup_logging(args.verbose);

    info!("Starting application");

    // Greet the user
    let name = args.name.unwrap_or_else(|| "World".to_string());
    println!("Hello, {}!", name);

    // Read file if provided
    if let Some(file_path) = args.file {
        if file_path.exists() {
            let content = tokio::fs::read_to_string(file_path).await?;
            println!("File content:\n{}", content);
        } else {
            println!("File not found: {:?}", file_path);
        }
    }

    // Create a sample data structure and serialize to JSON
    let data = serde_json::json!({
        "message": format!("Hello, {}!", name),
        "timestamp": chrono::Utc::now().to_rfc3339(),
    });
    
    println!("\nJSON data:\n{}", serde_json::to_string_pretty(&data)?);

    info!("Application completed successfully");
    Ok(())
}