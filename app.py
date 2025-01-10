import streamlit as st

# Title of the app
st.title("My Streamlit App")

# Sidebar
st.sidebar.header("Navigation")
page = st.sidebar.radio("Go to", ["Home", "About"])

# Home Page
if page == "Home":
    st.header("Welcome to the Home Page!")
    st.write("This is a simple Streamlit app.")
    
    # Input fields
    user_input = st.text_input("Enter something:")
    if user_input:
        st.write(f"You entered: {user_input}")

# About Page
elif page == "About":
    st.header("About This App")
    st.write("This app is created to demonstrate Streamlit's capabilities.")

# Footer
st.write("Made with ❤️ using Streamlit")
