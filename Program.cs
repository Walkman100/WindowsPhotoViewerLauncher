using System;
using System.IO;
using System.Windows.Forms;

namespace WindowsPhotoViewerLauncher {
    internal static class Program {
        static void Main(string[] args) {
            if (args == null || args.Length == 0) {
                MessageBox("No files provided!", icon: MessageBoxIcon.Error);
                return;
            }

            string photoViewerDLLPath = null;
            foreach (var envVar in new[] { "ProgramW6432", "ProgramFiles", "ProgramFiles(x86)" }) {
                photoViewerDLLPath = Path.Combine(Environment.GetEnvironmentVariable(envVar), "Windows Photo Viewer", "PhotoViewer.dll");
                if (File.Exists(photoViewerDLLPath))
                    break;
            }
            if (!File.Exists(photoViewerDLLPath)) {
                MessageBox("Could not find Windows Photo Viewer DLL!", icon: MessageBoxIcon.Error);
                return;
            }

            string runDLLPath = Path.Combine(Environment.GetEnvironmentVariable("WinDir"), "Sysnative", "rundll32.exe");
            if (!File.Exists(runDLLPath))
                runDLLPath = Path.Combine(Environment.GetEnvironmentVariable("WinDir"), "System32", "rundll32.exe");

            const string longFilePathPrefix = @"\\?\";
            const string longFilePathPrefixDoNotStrip = @"\\?\Volume{";

            foreach (string item in args) {
                string item2 = item;
                if (item2.StartsWith(longFilePathPrefix) && !item2.StartsWith(longFilePathPrefixDoNotStrip))
                    item2 = item2.Substring(longFilePathPrefix.Length); // Windows Photo Viewer (or maybe rundll32) doesn't like the absolute path prefix

                System.Diagnostics.Process.Start(runDLLPath, $"\"{photoViewerDLLPath}\", ImageView_Fullscreen {item2}");
            }
        }

        static DialogResult MessageBox(string message, string title = "Windows Photo Viewer Launcher",
                MessageBoxButtons buttons = MessageBoxButtons.OK, MessageBoxIcon icon = MessageBoxIcon.None,
                MessageBoxDefaultButton defaultButton = MessageBoxDefaultButton.Button1, MessageBoxOptions options = 0) {
            Application.EnableVisualStyles();
            return System.Windows.Forms.MessageBox.Show(message, title, buttons, icon, defaultButton, options);
        }
    }
}
