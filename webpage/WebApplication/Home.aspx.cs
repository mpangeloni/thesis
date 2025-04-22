using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("Page_Load method called");
            btnConfirm.Click += btnConfirm_Click;
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            // Check if the clicked button is the certain button
            if (sender == btnConfirm)
            {
                // Establish connection string
                string connectionString = "server=localhost;user=root;password=pi;database=exampledb";

                // Create connection
                MySqlConnection connection = new MySqlConnection(connectionString);

                try
                {
                    // Open the connection
                    connection.Open();

                    // Example interaction data
                    string interactionData = "User clicked";

                    // SQL query to insert interaction data into database
                    string query = "INSERT INTO interactions (hidden_button) VALUES (@interactionData)";

                    // Create MySqlCommand object
                    MySqlCommand cmd = new MySqlCommand(query, connection);

                    // Add parameters
                    cmd.Parameters.AddWithValue("@interactionData", interactionData);

                    // Execute the command
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    // Handle any exceptions
                    Console.WriteLine("Error: " + ex.Message);
                }
                finally
                {
                    // Close the connection
                    connection.Close();
                }
            }
        }


    }
}