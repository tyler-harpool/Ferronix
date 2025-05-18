use wasm_bindgen::prelude::*;

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[wasm_bindgen]
extern {
    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);
}

// A macro to provide `println!(..)` style syntax for `console.log` logging.
macro_rules! console_log {
    ($($t:tt)*) => (log(&format!($($t)*)));
}

#[wasm_bindgen]
pub fn init_panic_hook() {
    // When the `console_error_panic_hook` feature is enabled, we can call the
    // `set_panic_hook` function at least once during initialization, and then
    // we will get better error messages if our code ever panics.
    #[cfg(feature = "console_error_panic_hook")]
    console_error_panic_hook::set_once();
}

/// Simple addition function to demonstrate WebAssembly functionality
#[wasm_bindgen]
pub fn add(a: i32, b: i32) -> i32 {
    console_log!("Adding {} and {}", a, b);
    a + b
}

/// Takes a string name and returns a greeting
#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello, {}! Welcome to Ferronix WASM!", name)
}

/// A more complex example that works with JavaScript objects
#[wasm_bindgen]
pub fn process_data(data: JsValue) -> Result<JsValue, JsValue> {
    let input: serde_wasm_bindgen::Deserializer = serde_wasm_bindgen::Deserializer::from(data);
    let parsed_data: Vec<i32> = serde::Deserialize::deserialize(input)
        .map_err(|e| JsValue::from_str(&format!("Failed to parse input: {:?}", e)))?;
    
    let sum: i32 = parsed_data.iter().sum();
    let result = vec![sum, parsed_data.len() as i32];
    
    Ok(serde_wasm_bindgen::to_value(&result)?)
}